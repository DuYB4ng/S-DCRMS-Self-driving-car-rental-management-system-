using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Authorization;
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
        [AllowAnonymous]
        public async Task<IActionResult> Login([FromBody] LoginDto loginDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            // Tìm user theo email
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == loginDto.Email);
            if (user == null)
                return Unauthorized(new { message = "Invalid email or password" });

            // Kiểm tra mật khẩu
            if (user.Password != loginDto.Password)
                return Unauthorized(new { message = "Invalid email or password" });

            // Tạo JWT token
            var token = _jwtService.GenerateToken(user);

            var response = new
            {
                Email = user.Email,
                Role = user.Role.ToString(),
                LastName = user.LastName,
                FirstName = user.FirstName,
                Token = token,
            };

            return Ok(response);
        }

        [HttpPost("register-admin")]
        [AllowAnonymous]
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
                Password = createDto.Password,
            };

            _context.Users.Add(admin);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Admin registered successfully" });
        }
    }
}
