using SDCRMS.Dtos.Staff;
using SDCRMS.Models;
using System.Reflection.Metadata.Ecma335;

namespace SDCRMS.Mappers.Staff
{
    public static class NotificationOfStaff
    {
        public static Notification toNotificationOfStaffFromDto (this CreateNotificationsFromStaffDto NotiDto)
        {

            return new Notification
            {
                Message = NotiDto.Message,
                Title = NotiDto.Title,
                Read = NotiDto.Read,
                linkURL = NotiDto.linkURL
            };
        }
    }
}
