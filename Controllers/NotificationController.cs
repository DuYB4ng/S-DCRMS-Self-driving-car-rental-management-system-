using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SDCRMS.Authorization;
using SDCRMS.DTOs.Notification;
using SDCRMS.Mappers;
using SDCRMS.Models;

namespace SDCRMS.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class NotificationController : ControllerBase
    {
        private readonly AppDbContext _context;

        public NotificationController(AppDbContext context)
        {
            _context = context;
        }

        // Get: api/notification
        [HttpGet]
        [Authorize(Policy = AuthorizationPolicies.AuthenticatedUser)]
        public async Task<IActionResult> GetNotifications()
        {
            var notifications = await _context.Notifications.ToListAsync();
            var dtos = notifications.Select(n => n.ToNotificationDto()).ToList();
            return Ok(dtos);
        }

        // Get: api/notification/{id}
        [HttpGet("{id}")]
        [Authorize(Policy = AuthorizationPolicies.AuthenticatedUser)]
        public async Task<IActionResult> GetNotification(int id)
        {
            var notification = await _context.Notifications.FindAsync(id);
            if (notification == null)
            {
                return NotFound();
            }
            return Ok(notification.ToNotificationDto());
        }

        // Post: api/notification
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

        // Put: api/notification/{id}
        [HttpPut("{id}")]
        [Authorize(Policy = AuthorizationPolicies.AdminOnly)]
        public async Task<IActionResult> PutNotification(
            int id,
            [FromBody] CreateNotificationDto dto
        )
        {
            var existingNotification = await _context.Notifications.FindAsync(id);
            if (existingNotification == null)
            {
                return NotFound();
            }

            existingNotification.Title = dto.Title;
            existingNotification.Message = dto.Message;

            _context.Notifications.Update(existingNotification);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // Delete: api/notification/{id}
        [HttpDelete("{id}")]
        [Authorize(Policy = AuthorizationPolicies.AdminOnly)]
        public async Task<IActionResult> DeleteNotification(int id)
        {
            var notification = await _context.Notifications.FindAsync(id);
            if (notification == null)
            {
                return NotFound();
            }

            _context.Notifications.Remove(notification);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
