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
    // [Authorize(Policy = AuthorizationPolicies.AdminOnly)] // Tạm tắt để test
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
            var totalAdmins = await _context.Admins.CountAsync();

            return Ok(
                new
                {
                    TotalUsers = 100,
                    TotalAdmins = totalAdmins,
                    TotalStaff = 10,
                    TotalCustomers = 90,
                    Message = "Admin dashboard data (mock)",
                }
            );

            /*
            var client = _httpClientFactory.CreateClient();
            var userServiceUrl = _configuration["ServiceUrls:UserService"];

            try
            {
                var response = await client.GetAsync($"{userServiceUrl}/api/user/statistics");

                if (response.IsSuccessStatusCode)
                {
                    var userStats = await response.Content.ReadFromJsonAsync<UserStatisticsDto>();

                    return Ok(
                        new
                        {
                            TotalUsers = userStats?.TotalUsers ?? 0,
                            TotalAdmins = totalAdmins,
                            TotalStaff = userStats?.TotalStaff ?? 0,
                            TotalCustomers = userStats?.TotalCustomers ?? 0,
                            Message = "Admin dashboard data",
                        }
                    );
                }
                else
                {
                    return Ok(
                        new
                        {
                            TotalUsers = 0,
                            TotalAdmins = totalAdmins,
                            TotalStaff = 0,
                            TotalCustomers = 0,
                            Message = "Admin dashboard data (User Service unavailable)",
                        }
                    );
                }
            }
            catch (Exception ex)
            {
                return StatusCode(
                    500,
                    new { message = "Error connecting to User Service", error = ex.Message }
                );
            }
            */
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
                    $"{userServiceUrl}/api/user/{userId}/promote",
                    new { Role = newRole }
                );

                if (response.IsSuccessStatusCode)
                {
                    // Tạo notification sau khi promote thành công
                    await _context.Notifications.AddAsync(
                        new Models.Notification
                        {
                            UserID = userId,
                            Title = "Role Updated",
                            Message = $"Your role has been updated to {newRole}",
                            CreatedAt = DateTime.UtcNow,
                            Read = false,
                            LinkURL = "",
                        }
                    );
                    await _context.SaveChangesAsync();

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
    }

    // DTO for User Service response
    public class UserStatisticsDto
    {
        public int TotalUsers { get; set; }
        public int TotalStaff { get; set; }
        public int TotalCustomers { get; set; }
    }
}
