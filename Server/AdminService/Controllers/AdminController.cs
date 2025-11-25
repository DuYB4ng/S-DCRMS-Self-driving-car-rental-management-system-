using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SDCRMS.Authorization;
using SDCRMS.Data;
using SDCRMS.DTOs.Admin;
using SDCRMS.Mapper;
using SDCRMS.Services;

namespace SDCRMS.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AdminController : ControllerBase
    {
        private readonly IAdminServices _adminServices;
        private readonly AdminDbContext _context;
        private readonly IPasswordHasher _passwordHasher;
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly IConfiguration _configuration;

        public AdminController(
            IAdminServices adminServices,
            AdminDbContext context,
            IPasswordHasher passwordHasher,
            IHttpClientFactory httpClientFactory,
            IConfiguration configuration
        )
        {
            _adminServices = adminServices;
            _context = context;
            _passwordHasher = passwordHasher;
            _httpClientFactory = httpClientFactory;
            _configuration = configuration;
        }

        // GET: api/admin
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var admins = await _context.Admins.ToListAsync();
            var adminDtos = admins.Select(a => a.ToAdminDto()).ToList();
            return Ok(adminDtos);
        }

        // GET: api/admin/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById([FromRoute] int id)
        {
            var admin = await _context.Admins.FindAsync(id);
            if (admin == null)
                return NotFound(new { message = "Admin not found" });

            return Ok(admin.ToAdminDto());
        }

        // GET: api/admin/dashboard - Gọi sang User Service để lấy statistics
        [HttpGet("dashboard")]
        public async Task<IActionResult> GetDashboardData()
        {
            // Tạm thời trả về mock data vì User Service chưa tồn tại
            var totalAdmins = await _context.Admins.CountAsync();
            var totalUsers = await _context.Users.CountAsync();

            return Ok(
                new
                {
                    TotalUsers = totalUsers,
                    TotalAdmins = totalAdmins,
                    TotalStaff = 0, // TODO: Khi có User Service sẽ call API
                    TotalCustomers = 0, // TODO: Khi có User Service sẽ call API
                    Message = "Admin dashboard data (User Service not available yet)",
                }
            );
        }

        // POST: api/admin/promote-user - Gọi sang User Service
        [HttpPost("promote-user/{userId}")]
        public async Task<IActionResult> PromoteUser(int userId, [FromQuery] string newRole)
        {
            var client = _httpClientFactory.CreateClient();
            var userServiceUrl = _configuration["ServiceUrls:UserService"];

            try
            {
                var response = await client.PostAsJsonAsync(
                    $"{userServiceUrl}/api/users/{userId}/promote",
                    new { role = newRole }
                );

                if (response.IsSuccessStatusCode)
                {
                    // TODO: Call NotificationService to create notification
                    return Ok(new { message = $"User promoted to {newRole}" });
                }

                return BadRequest(new { message = "Failed to promote user" });
            }
            catch (Exception ex)
            {
                return StatusCode(
                    500,
                    new { message = "Error connecting to User Service", error = ex.Message }
                );
            }
        }

        // POST: api/admin
        [HttpPost]
        public async Task<IActionResult> CreateAdmin([FromBody] CreateAdminDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var exists = await _context.Admins.AnyAsync(u => u.Email == dto.Email);
            if (exists)
                return BadRequest(new { message = "Email already exists" });

            var admin = dto.ToAdmin();
            var createdAdmin = await _adminServices.TaoAdminAsync(admin, dto.Password);

            return CreatedAtAction(
                nameof(GetById),
                new { id = createdAdmin.UserID },
                createdAdmin.ToAdminDto()
            );
        }

        // DELETE: api/admin/by-email/{email}
        [HttpDelete("by-email/{email}")]
        public async Task<IActionResult> DeleteAdminByEmail([FromRoute] string email)
        {
            var admin = await _context.Admins.FirstOrDefaultAsync(a => a.Email == email);
            if (admin == null)
                return NotFound(new { message = "Admin not found" });

            _context.Admins.Remove(admin);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Admin deleted successfully" });
        }
    }

    // DTO for User Service response
    public class UserStatisticsDto
    {
        public int TotalUsers { get; set; }
        public int TotalStaff { get; set; }
        public int TotalCustomers { get; set; }
    }
}
