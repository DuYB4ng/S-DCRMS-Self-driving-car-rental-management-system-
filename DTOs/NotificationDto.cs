namespace SDCRMS.DTOs.Notification
{
    public class NotificationDto
    {
        public int NotificationID { get; set; }
        public int UserID { get; set; }
        public string Message { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
        public string Title { get; set; } = string.Empty;
        public bool Read { get; set; }
    }
}
