using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SDCRMS.DTOs.Admin;
using SDCRMS.Mapper;

namespace SDCRMS.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = "Admin")]
    public class AdminController : ControllerBase
    {
        private readonly AppDbContext _context;

        public AdminController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/admin - chỉ Admin mới được truy cập
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var admins = await _context
                .Users.Where(u => u.Role == Models.Enums.UserRole.Admin)
                .ToListAsync();
            var adminDtos = admins
                .Select(a => new AdminDto
                {
                    UserID = a.UserID,
                    Email = a.Email,
                    FirstName = a.FirstName,
                    LastName = a.LastName,
                    PhoneNumber = a.PhoneNumber,
                    JoinDate = a.JoinDate,
                })
                .ToList();
            return Ok(adminDtos);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById([FromRoute] int id)
        {
            var admin = await _context.Users.FirstOrDefaultAsync(u =>
                u.UserID == id && u.Role == Models.Enums.UserRole.Admin
            );
            if (admin == null)
                return NotFound(new { message = "Admin not found" });

            var adminDto = new AdminDto
            {
                UserID = admin.UserID,
                Email = admin.Email,
                FirstName = admin.FirstName,
                LastName = admin.LastName,
                PhoneNumber = admin.PhoneNumber,
                JoinDate = admin.JoinDate,
            };

            return Ok(adminDto);
        }

        // GET: api/admin/dashboard - Dashboard chỉ cho Admin
        [HttpGet("dashboard")]
        public async Task<IActionResult> GetDashboardData()
        {
            var totalUsers = await _context.Users.CountAsync();
            var totalAdmins = await _context.Users.CountAsync(u =>
                u.Role == Models.Enums.UserRole.Admin
            );
            var totalStaff = await _context.Users.CountAsync(u =>
                u.Role == Models.Enums.UserRole.Staff
            );
            var totalCustomers = await _context.Users.CountAsync(u =>
                u.Role == Models.Enums.UserRole.Customer
            );

            return Ok(
                new
                {
                    TotalUsers = totalUsers,
                    TotalAdmins = totalAdmins,
                    TotalStaff = totalStaff,
                    TotalCustomers = totalCustomers,
                    Message = "Admin dashboard data",
                }
            );
        }

        // POST: api/admin/promote-user - Chỉ Admin mới có thể thăng cấp user
        [HttpPost("promote-user/{userId}")]
        public async Task<IActionResult> PromoteUser(int userId, [FromQuery] string newRole)
        {
            var user = await _context.Users.FindAsync(userId);
            if (user == null)
                return NotFound(new { message = "User not found" });

            if (Enum.TryParse<Models.Enums.UserRole>(newRole, true, out var role))
            {
                user.Role = role;
                await _context.SaveChangesAsync();
                return Ok(new { message = $"User promoted to {role}" });
            }

            return BadRequest(new { message = "Invalid role" });
        }

        // POST: api/admin - Tạo admin mới (chỉ Admin)
        [HttpPost]
        public async Task<IActionResult> CreateAdmin([FromBody] CreateAdminDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            // Không cho trùng email
            var exists = await _context.Users.AnyAsync(u => u.Email == dto.Email);
            if (exists)
                return BadRequest(new { message = "Email already exists" });

            // Map DTO -> Admin entity
            var admin = dto.ToAdmin();
            admin.JoinDate = DateTime.UtcNow;

            _context.Admins.Add(admin);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetById), new { id = admin.UserID }, admin.ToAdminDto());
        }
    }
}
