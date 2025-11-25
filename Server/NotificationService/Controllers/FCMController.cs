using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SDCRMS.Authorization;
using SDCRMS.Data;
using SDCRMS.DTOs.FCM;
using SDCRMS.Models;

namespace SDCRMS.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class FCMController : ControllerBase
    {
        private readonly NotificationDbContext _context;

        public FCMController(NotificationDbContext context)
        {
            _context = context;
        }

        // POST: api/fcm/register
        [HttpPost("register")]
        [Authorize(Policy = AuthorizationPolicies.AuthenticatedUser)]
        public async Task<IActionResult> RegisterToken([FromBody] RegisterFCMTokenDto dto)
        {
            try
            {
                // Lấy UserID từ claims
                var userIdClaim = User.FindFirst("UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int userId))
                {
                    return Unauthorized(new { message = "Invalid user" });
                }

                // Kiểm tra token đã tồn tại chưa
                var existingToken = await _context
                    .FCMTokens.Where(t => t.UserID == userId && t.Token == dto.Token)
                    .FirstOrDefaultAsync();

                if (existingToken != null)
                {
                    // Cập nhật token hiện tại
                    existingToken.IsActive = true;
                    existingToken.LastUsedAt = DateTime.UtcNow;
                    existingToken.DeviceType = dto.DeviceType;
                }
                else
                {
                    // Tạo token mới
                    var fcmToken = new FCMToken
                    {
                        UserID = userId,
                        Token = dto.Token,
                        DeviceType = dto.DeviceType,
                        CreatedAt = DateTime.UtcNow,
                        IsActive = true,
                    };

                    _context.FCMTokens.Add(fcmToken);
                }

                await _context.SaveChangesAsync();

                return Ok(new { message = "FCM token registered successfully" });
            }
            catch (Exception ex)
            {
                return StatusCode(
                    500,
                    new { message = "Error registering FCM token", error = ex.Message }
                );
            }
        }

        // DELETE: api/fcm/unregister
        [HttpDelete("unregister")]
        [Authorize(Policy = AuthorizationPolicies.AuthenticatedUser)]
        public async Task<IActionResult> UnregisterToken([FromBody] string token)
        {
            try
            {
                var userIdClaim = User.FindFirst("UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int userId))
                {
                    return Unauthorized(new { message = "Invalid user" });
                }

                var fcmToken = await _context
                    .FCMTokens.Where(t => t.UserID == userId && t.Token == token)
                    .FirstOrDefaultAsync();

                if (fcmToken == null)
                {
                    return NotFound(new { message = "Token not found" });
                }

                fcmToken.IsActive = false;
                await _context.SaveChangesAsync();

                return Ok(new { message = "FCM token unregistered successfully" });
            }
            catch (Exception ex)
            {
                return StatusCode(
                    500,
                    new { message = "Error unregistering FCM token", error = ex.Message }
                );
            }
        }

        // GET: api/fcm/my-tokens
        [HttpGet("my-tokens")]
        [Authorize(Policy = AuthorizationPolicies.AuthenticatedUser)]
        public async Task<IActionResult> GetMyTokens()
        {
            try
            {
                var userIdClaim = User.FindFirst("UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int userId))
                {
                    return Unauthorized(new { message = "Invalid user" });
                }

                var tokens = await _context
                    .FCMTokens.Where(t => t.UserID == userId && t.IsActive)
                    .Select(t => new FCMTokenDto
                    {
                        TokenID = t.TokenID,
                        UserID = t.UserID,
                        Token = t.Token,
                        DeviceType = t.DeviceType,
                        CreatedAt = t.CreatedAt,
                        LastUsedAt = t.LastUsedAt,
                        IsActive = t.IsActive,
                    })
                    .ToListAsync();

                return Ok(tokens);
            }
            catch (Exception ex)
            {
                return StatusCode(
                    500,
                    new { message = "Error fetching FCM tokens", error = ex.Message }
                );
            }
        }

        // GET: api/fcm/all-tokens (Admin only)
        [HttpGet("all-tokens")]
        [Authorize(Policy = AuthorizationPolicies.AdminOnly)]
        public async Task<IActionResult> GetAllTokens()
        {
            try
            {
                var tokens = await _context
                    .FCMTokens.Where(t => t.IsActive)
                    .Select(t => new FCMTokenDto
                    {
                        TokenID = t.TokenID,
                        UserID = t.UserID,
                        Token = t.Token,
                        DeviceType = t.DeviceType,
                        CreatedAt = t.CreatedAt,
                        LastUsedAt = t.LastUsedAt,
                        IsActive = t.IsActive,
                    })
                    .ToListAsync();

                return Ok(new { count = tokens.Count, tokens });
            }
            catch (Exception ex)
            {
                return StatusCode(
                    500,
                    new { message = "Error fetching FCM tokens", error = ex.Message }
                );
            }
        }

        // DELETE: api/fcm/cleanup-inactive (Admin only)
        [HttpDelete("cleanup-inactive")]
        [Authorize(Policy = AuthorizationPolicies.AdminOnly)]
        public async Task<IActionResult> CleanupInactiveTokens()
        {
            try
            {
                // Xóa các tokens inactive hoặc quá 90 ngày không dùng
                var cutoffDate = DateTime.UtcNow.AddDays(-90);
                var tokensToRemove = await _context
                    .FCMTokens.Where(t =>
                        !t.IsActive || (t.LastUsedAt.HasValue && t.LastUsedAt < cutoffDate)
                    )
                    .ToListAsync();

                _context.FCMTokens.RemoveRange(tokensToRemove);
                await _context.SaveChangesAsync();

                return Ok(
                    new { message = "Inactive tokens cleaned up", count = tokensToRemove.Count }
                );
            }
            catch (Exception ex)
            {
                return StatusCode(
                    500,
                    new { message = "Error cleaning up tokens", error = ex.Message }
                );
            }
        }
    }
}
