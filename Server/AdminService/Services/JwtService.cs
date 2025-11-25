using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using SDCRMS.Models;

namespace SDCRMS.Services
{
    public interface IJwtService
    {
        string GenerateToken(Users user);
    }

    public class JwtService : IJwtService
    {
        private readonly IConfiguration _configuration;

        public JwtService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        // Tạo JWT đơn giản (HS256) kèm Role claim để dùng với [Authorize(Roles = "Admin")]
        public string GenerateToken(Users user)
        {
            var jwt = _configuration.GetSection("JwtSettings");
            var secret = jwt["Secret"];
            if (string.IsNullOrWhiteSpace(secret))
            {
                throw new InvalidOperationException("Missing JwtSettings:Secret");
            }

            var issuer = jwt["Issuer"];
            var audience = jwt["Audience"];

            double expiryInHours;
            if (!double.TryParse(jwt["ExpiryInHours"], out expiryInHours))
            {
                expiryInHours = 24d;
            }

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, user.UserID.ToString()),
                new Claim(ClaimTypes.Email, user.Email ?? string.Empty),
                new Claim(ClaimTypes.Name, ($"{user.FirstName} {user.LastName}").Trim()),
                new Claim(ClaimTypes.Role, user.Role.ToString()),
                new Claim("role", user.Role.ToString()),
            };

            var descriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.UtcNow.AddHours(expiryInHours),
                SigningCredentials = creds,
                Issuer = issuer,
                Audience = audience,
            };

            var handler = new JwtSecurityTokenHandler();
            var token = handler.CreateToken(descriptor);
            return handler.WriteToken(token);
        }
    }
}
