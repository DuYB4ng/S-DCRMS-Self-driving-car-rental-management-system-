using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SDCRMS.Authorization;
using SDCRMS.Data;
using SDCRMS.DTOs.Notification;
using SDCRMS.Mappers;
using SDCRMS.Models;

namespace SDCRMS.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    // Tạm comment authorization để test
    public class NotificationController : ControllerBase
    {
        private readonly AdminDbContext _context;
        private readonly IConfiguration _configuration;
        private readonly IHttpClientFactory _httpClientFactory;

        public NotificationController(
            AdminDbContext context,
            IConfiguration configuration,
            IHttpClientFactory httpClientFactory
        )
        {
            _context = context;
            _configuration = configuration;
            _httpClientFactory = httpClientFactory;
        }

        // GET: api/notification
        [HttpGet]
        [Authorize(Policy = AuthorizationPolicies.AuthenticatedUser)]
        public async Task<IActionResult> GetNotifications()
        {
            var notifications = await _context
                .Notifications.OrderByDescending(n => n.CreatedAt)
                .ToListAsync();
            var dtos = notifications.Select(n => n.ToNotificationDto()).ToList();
            return Ok(dtos);
        }

        // GET: api/notification/{id}
        [HttpGet("{id}")]
        [Authorize(Policy = AuthorizationPolicies.AuthenticatedUser)]
        public async Task<IActionResult> GetNotification(int id)
        {
            var notification = await _context.Notifications.FindAsync(id);
            if (notification == null)
                return NotFound();

            return Ok(notification.ToNotificationDto());
        }

        // GET: api/notification/user/{userId}
        [HttpGet("user/{userId}")]
        [Authorize(Policy = AuthorizationPolicies.AuthenticatedUser)]
        public async Task<IActionResult> GetUserNotifications(int userId)
        {
            var notifications = await _context
                .Notifications.Where(n => n.UserID == userId)
                .OrderByDescending(n => n.CreatedAt)
                .ToListAsync();

            var dtos = notifications.Select(n => n.ToNotificationDto()).ToList();
            return Ok(dtos);
        }

        // POST: api/notification
        [HttpPost]
        [Authorize(Policy = AuthorizationPolicies.AdminOnly)]
        public async Task<IActionResult> PostNotification([FromBody] CreateNotificationDto dto)
        {
            var notification = dto.ToNotification();
            _context.Notifications.Add(notification);
            await _context.SaveChangesAsync();

            return CreatedAtAction(
                nameof(GetNotification),
                new { id = notification.NotificationID },
                notification.ToNotificationDto()
            );
        }

        // POST: api/notification/broadcast - Gửi notification cho tất cả users
        [HttpPost("broadcast")]
        [Authorize(Policy = AuthorizationPolicies.AdminOnly)]
        public async Task<IActionResult> BroadcastNotification([FromBody] CreateNotificationDto dto)
        {
            // Lấy danh sách UserIDs từ User Service
            var client = _httpClientFactory.CreateClient();
            var userServiceUrl = _configuration["ServiceUrls:UserService"];

            try
            {
                var response = await client.GetAsync($"{userServiceUrl}/api/user/all-ids");

                if (response.IsSuccessStatusCode)
                {
                    var userIds = await response.Content.ReadFromJsonAsync<List<int>>();

                    // Bulk insert - tạo tất cả notifications một lúc
                    var notifications = (userIds ?? new List<int>())
                        .Select(userId => new Notification
                        {
                            UserID = userId,
                            Title = dto.Title,
                            Message = dto.Message,
                            CreatedAt = DateTime.UtcNow,
                            Read = false,
                            LinkURL = "",
                        })
                        .ToList();

                    _context.Notifications.AddRange(notifications);
                    await _context.SaveChangesAsync();

                    return Ok(
                        new
                        {
                            message = "Notification broadcasted successfully",
                            count = notifications.Count,
                        }
                    );
                }

                return StatusCode(500, new { message = "Failed to fetch users" });
            }
            catch (Exception ex)
            {
                return StatusCode(
                    500,
                    new { message = "Error connecting to User Service", error = ex.Message }
                );
            }
        }

        // PUT: api/notification/{id}
        [HttpPut("{id}")]
        [Authorize(Policy = AuthorizationPolicies.AdminOnly)]
        public async Task<IActionResult> PutNotification(
            int id,
            [FromBody] UpdateNotificationDto dto
        )
        {
            var existingNotification = await _context.Notifications.FindAsync(id);
            if (existingNotification == null)
                return NotFound();

            existingNotification.Title = dto.Title;
            existingNotification.Message = dto.Message;

            await _context.SaveChangesAsync();
            return NoContent();
        }

        // PUT: api/notification/{id}/read
        [HttpPut("{id}/read")]
        [Authorize(Policy = AuthorizationPolicies.AuthenticatedUser)]
        public async Task<IActionResult> MarkAsRead(int id)
        {
            var notification = await _context.Notifications.FindAsync(id);
            if (notification == null)
                return NotFound();

            notification.Read = true;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/notification/{id}
        [HttpDelete("{id}")]
        [Authorize(Policy = AuthorizationPolicies.AdminOnly)]
        public async Task<IActionResult> DeleteNotification(int id)
        {
            var notification = await _context.Notifications.FindAsync(id);
            if (notification == null)
                return NotFound();

            _context.Notifications.Remove(notification);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
