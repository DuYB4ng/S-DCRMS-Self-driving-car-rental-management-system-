using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SDCRMS.DTOs.Admin;
using SDCRMS.DTOs.Notification;
using SDCRMS.Mappers;
using SDCRMS.Models;
using SDCRMS.Services;

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
        public async Task<IActionResult> GetNotifications()
        {
            var notifications = await _context.Notifications.ToListAsync();
            var dtos = notifications.Select(n => n.ToNotificationDto()).ToList();
            return Ok(dtos);
        }

        // Get: api/notification/{id}
        [HttpGet("{id}")]
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
    }
}
