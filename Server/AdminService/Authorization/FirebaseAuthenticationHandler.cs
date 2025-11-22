using System.Security.Claims;
using System.Text.Encodings.Web;
using System.Threading.Tasks;
using FirebaseAdmin.Auth;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace SDCRMS.Authorization
{
    public class FirebaseAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        public const string SchemeName = "Firebase";

        public FirebaseAuthenticationHandler(
            IOptionsMonitor<AuthenticationSchemeOptions> options,
            ILoggerFactory logger,
            UrlEncoder encoder
        )
            : base(options, logger, encoder) { }

        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Request.Headers.ContainsKey("Authorization"))
                return AuthenticateResult.Fail("Missing Authorization Header");

            string? bearerToken = Request.Headers["Authorization"].FirstOrDefault();
            if (string.IsNullOrEmpty(bearerToken) || !bearerToken.StartsWith("Bearer "))
                return AuthenticateResult.Fail("Invalid Authorization Header");

            string token = bearerToken.Substring("Bearer ".Length).Trim();

            try
            {
                var decodedToken = await FirebaseAuth.DefaultInstance.VerifyIdTokenAsync(token);
                var claims = new List<Claim>
                {
                    new Claim(ClaimTypes.NameIdentifier, decodedToken.Uid),
                    new Claim(ClaimTypes.Name, decodedToken.Uid),
                };

                if (decodedToken.Claims.TryGetValue("email", out var emailObj) && emailObj != null)
                {
                    claims.Add(new Claim(ClaimTypes.Email, emailObj.ToString()!));
                }
                if (decodedToken.Claims.TryGetValue("role", out var roleObj) && roleObj != null)
                {
                    claims.Add(new Claim(ClaimTypes.Role, roleObj.ToString()!));
                }
                else if (
                    decodedToken.Claims.TryGetValue("admin", out var adminObj)
                    && adminObj is bool b
                    && b
                )
                {
                    claims.Add(new Claim(ClaimTypes.Role, "Admin"));
                }
                else
                {
                    claims.Add(new Claim(ClaimTypes.Role, "Staff"));
                }

                var identity = new ClaimsIdentity(claims, SchemeName);
                var principal = new ClaimsPrincipal(identity);
                var ticket = new AuthenticationTicket(principal, SchemeName);
                return AuthenticateResult.Success(ticket);
            }
            catch (FirebaseAuthException ex)
            {
                Logger.LogError(ex, "Firebase token verification failed");
                return AuthenticateResult.Fail("Invalid Firebase token");
            }
            catch (Exception ex)
            {
                Logger.LogError(ex, "Unexpected error during token verification");
                return AuthenticateResult.Fail("Authentication error");
            }
        }
    }
}
