using System.Security.Claims;
using System.Text;
using FirebaseAdmin;
using FirebaseAdmin.Auth;
using Google.Apis.Auth.OAuth2;

namespace Gateway.Middleware
{
    public class FirebaseAuthMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<FirebaseAuthMiddleware> _logger;

        public FirebaseAuthMiddleware(RequestDelegate next, ILogger<FirebaseAuthMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            // Skip authentication for public endpoints
            if (IsPublicEndpoint(context.Request.Path))
            {
                await _next(context);
                return;
            }

            var authHeader = context.Request.Headers["Authorization"].ToString();
            if (string.IsNullOrEmpty(authHeader) || !authHeader.StartsWith("Bearer "))
            {
                _logger.LogWarning("Missing or invalid Authorization header");
                await _next(context);
                return;
            }

            var token = authHeader.Substring("Bearer ".Length).Trim();

            try
            {
                // Verify Firebase token
                var decodedToken = await FirebaseAuth.DefaultInstance.VerifyIdTokenAsync(token);

                // Attach user info to HttpContext
                var claims = new List<Claim>
                {
                    new Claim(ClaimTypes.NameIdentifier, decodedToken.Uid),
                    new Claim(
                        ClaimTypes.Email,
                        decodedToken.Claims.GetValueOrDefault("email")?.ToString() ?? ""
                    ),
                };

                // Add custom claims (role)
                if (decodedToken.Claims.TryGetValue("role", out var roleObj))
                {
                    claims.Add(new Claim(ClaimTypes.Role, roleObj.ToString()!));
                }
                else if (
                    decodedToken.Claims.TryGetValue("admin", out var adminObj) && (bool)adminObj
                )
                {
                    claims.Add(new Claim(ClaimTypes.Role, "Admin"));
                }
                else
                {
                    claims.Add(new Claim(ClaimTypes.Role, "Staff"));
                }

                var identity = new ClaimsIdentity(claims, "Firebase");
                context.User = new ClaimsPrincipal(identity);

                _logger.LogInformation("Firebase token verified for user: {Uid}", decodedToken.Uid);
            }
            catch (FirebaseAuthException ex)
            {
                _logger.LogError(ex, "Firebase token verification failed");
                context.Response.StatusCode = 401;
                await context.Response.WriteAsync("Invalid token");
                return;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during token verification");
            }

            await _next(context);
        }

        private bool IsPublicEndpoint(PathString path)
        {
            var publicPaths = new[] { "/api/auth/login", "/api/auth/register", "/health" };
            return publicPaths.Any(p =>
                path.StartsWithSegments(p, StringComparison.OrdinalIgnoreCase)
            );
        }
    }

    public static class FirebaseAuthMiddlewareExtensions
    {
        public static IApplicationBuilder UseFirebaseAuth(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<FirebaseAuthMiddleware>();
        }
    }
}
