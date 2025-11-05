using Microsoft.EntityFrameworkCore;
using SDCRMS.Data;
using SDCRMS.Models;

namespace SDCRMS.Repositories
{
    public interface INotificationRepository
    {
        Task<IEnumerable<Notification>> LayTatCaThongBaoAsync();
        Task<Notification?> LayThongBaoTheoIdAsync(int id);
        Task<Notification> ThemThongBaoAsync(Notification notification);
        Task<Notification?> CapNhatThongBaoAsync(Notification notification);
        Task<bool> XoaThongBaoAsync(int id);
    }

    public class NotificationRepository : INotificationRepository
    {
        private readonly AdminDbContext _context;

        public NotificationRepository(AdminDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Notification>> LayTatCaThongBaoAsync()
        {
            return await _context.Notifications.ToListAsync();
        }

        public async Task<Notification?> LayThongBaoTheoIdAsync(int id)
        {
            return await _context.Notifications.FindAsync(id);
        }

        public async Task<Notification> ThemThongBaoAsync(Notification notification)
        {
            _context.Notifications.Add(notification);
            await _context.SaveChangesAsync();
            return notification;
        }

        public async Task<bool> XoaThongBaoAsync(int id)
        {
            var notification = await _context.Notifications.FindAsync(id);
            if (notification == null)
                return false;

            _context.Notifications.Remove(notification);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<Notification?> CapNhatThongBaoAsync(Notification notification)
        {
            var existingNotification = await _context.Notifications.FindAsync(
                notification.NotificationID
            );
            if (existingNotification == null)
                return null;

            existingNotification.UserID = notification.UserID;
            existingNotification.Title = notification.Title;
            existingNotification.Message = notification.Message;
            existingNotification.LinkURL = notification.LinkURL;

            await _context.SaveChangesAsync();
            return existingNotification;
        }
    }
}
