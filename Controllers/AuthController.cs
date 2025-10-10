using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SDCRMS.DTOs.Admin;
using SDCRMS.DTOs.Auth;
using SDCRMS.Models.Enums;
using SDCRMS.Services;

namespace SDCRMS.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IJwtService _jwtService;

        public AuthController(AppDbContext context, IJwtService jwtService)
        {
            _context = context;
            _jwtService = jwtService;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDto loginDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            // Tìm user theo email
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == loginDto.Email);
            if (user == null)
                return Unauthorized(new { message = "Invalid email or password" });

            // Kiểm tra mật khẩu
            if (!VerifyPassword(loginDto.Password, user.PasswordHash))
                return Unauthorized(new { message = "Invalid email or password" });

            // Tạo JWT token
            var token = _jwtService.GenerateToken(user);

            var response = new LoginResponseDto
            {
                Token = token,
                Email = user.Email,
                Role = user.Role.ToString(),
                FullName = $"{user.FirstName} {user.LastName}",
                ExpiresAt = DateTime.UtcNow.AddHours(24),
            };

            return Ok(response);
        }

        [HttpPost("register-admin")]
        public async Task<IActionResult> RegisterAdmin([FromBody] CreateAdminDto createDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            // Kiểm tra email đã tồn tại
            if (await _context.Users.AnyAsync(u => u.Email == createDto.Email))
                return BadRequest(new { message = "Email already exists" });

            // Tạo admin user mới
            var admin = new Models.Admin
            {
                Email = createDto.Email,
                FirstName = createDto.FirstName,
                LastName = createDto.LastName,
                PhoneNumber = createDto.PhoneNumber,
                Role = UserRole.Admin,
                JoinDate = DateTime.UtcNow,
                Address = createDto.Address,
                Sex = createDto.Sex,
                Birthday = createDto.Birthday,
            };

            _context.Users.Add(admin);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Admin registered successfully" });
        }

        private string HashPassword(string password)
        {
            using var sha256 = SHA256.Create();
            var hashedBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password + "SDCRMS_SALT"));
            return Convert.ToBase64String(hashedBytes);
        }

        private bool VerifyPassword(string password, string hash)
        {
            var computedHash = HashPassword(password);
            return computedHash == hash;
        }
    }
}
