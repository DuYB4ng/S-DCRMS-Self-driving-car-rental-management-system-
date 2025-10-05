namespace SDCRMS.DTOs.Notification
{
    public class CreateNotificationDto
    {
        public int UserID { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Message { get; set; } = string.Empty;
        public string LinkURL { get; set; } = string.Empty;
    }
}
