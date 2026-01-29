using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using NotificationService.Enums;
using NotificationService.Dtos;

namespace NotificationService.Controllers
{
    [ApiController]
    [Route("api/admin")]
    [Authorize(Roles = "Admin")]
    public class AdminController : ControllerBase
    {
        private readonly IUserRepository _userRepository;

        public AdminController(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        // 1️⃣ Lấy danh sách user
        [HttpGet("users")]
        public async Task<IActionResult> GetAllUsers()
        {
            var users = await _userRepository.GetAllAsync();
            return Ok(users);
        }

        // 2️⃣ Đổi role user
        [HttpPut("users/{userId}/role")]
        public async Task<IActionResult> UpdateUserRole(
            Guid userId,
            [FromBody] UpdateUserRoleDto request)
        {
            var user = await _userRepository.GetByIdAsync(userId);
            if (user == null)
                return NotFound("User not found");

            user.Role = request.Role;
            await _userRepository.UpdateAsync(user);

            return Ok(new
            {
                Message = "Role updated successfully",
                UserId = userId,
                NewRole = request.Role
            });
        }

        // 3️⃣ Thống kê cho dashboard
        [HttpGet("stats")]
        public async Task<IActionResult> GetAdminStats()
        {
            var users = await _userRepository.GetAllAsync();

            return Ok(new
            {
                TotalUsers = users.Count(),
                TotalAdmins = users.Count(u => u.Role == UserRole.Admin),
                TotalStaffs = users.Count(u => u.Role == UserRole.Staff),
                TotalCustomers = users.Count(u => u.Role == UserRole.Customer)
            });
        }
    }
}
