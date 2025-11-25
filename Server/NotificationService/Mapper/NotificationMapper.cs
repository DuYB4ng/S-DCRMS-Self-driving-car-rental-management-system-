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

    public static class CreateNotificationDtoMapper
    {
        // Map CreateNotificationDto -> Notification entity
        public static Notification ToNotification(this CreateNotificationDto dto)
        {
            return new Notification
            {
                Title = dto.Title,
                Message = dto.Message,
                CreatedAt = DateTime.UtcNow,
                Read = false,
            };
        }
    }
}

