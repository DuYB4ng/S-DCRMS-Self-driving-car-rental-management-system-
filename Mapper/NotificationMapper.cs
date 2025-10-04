using SDCRMS.DTOs.Notification;
using SDCRMS.Models;

namespace SDCRMS.Mappers
{
    public static class NotificationMapper
    {
        public static NotificationDto ToNotificationDto(this Notification notification)
        {
            return new NotificationDto
            {
                NotificationID = notification.NotificationID,
                Title = notification.Title,
                Message = notification.Message,
                CreatedAt = notification.CreatedAt,
                Read = notification.Read,
            };
        }
    }
}
