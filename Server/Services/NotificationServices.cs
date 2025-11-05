using SDCRMS.Models;
using SDCRMS.Repositories;

namespace SDCRMS.Services
{
    public interface INotificationServices
    {
        Task<IEnumerable<Notification>> LayTatCaThongBaoAsync();
        Task<Notification?> LayThongBaoTheoIdAsync(int id);
        Task<Notification> ThemThongBaoAsync(Notification notification);
        Task<Notification?> CapNhatThongBaoAsync(Notification notification);
        Task<bool> XoaThongBaoAsync(int id);
    }

    public class NotificationServices : INotificationServices
    {
        public readonly INotificationRepository _context;

        public NotificationServices(INotificationRepository context)
        {
            _context = context;
        }

        public async Task<Notification> ThemThongBaoAsync(Notification notification)
        {
            return await _context.ThemThongBaoAsync(notification);
        }

        public async Task<bool> XoaThongBaoAsync(int id)
        {
            return await _context.XoaThongBaoAsync(id);
        }

        public async Task<Notification?> CapNhatThongBaoAsync(Notification notification)
        {
            return await _context.CapNhatThongBaoAsync(notification);
        }

        public async Task<IEnumerable<Notification>> LayTatCaThongBaoAsync()
        {
            return await _context.LayTatCaThongBaoAsync();
        }

        public async Task<Notification?> LayThongBaoTheoIdAsync(int id)
        {
            return await _context.LayThongBaoTheoIdAsync(id);
        }
    }
}
