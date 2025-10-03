using SDCRMS.Models;

namespace SDCRMS.DTOs.Notification
{
    public class CreateNotificationDto
    {
        public int UserID { get; set; }
        public string Message { get; set; } = string.Empty;
        public string Title { get; set; } = string.Empty;
        public string LinkURL { get; set; } = string.Empty;
    }
}
