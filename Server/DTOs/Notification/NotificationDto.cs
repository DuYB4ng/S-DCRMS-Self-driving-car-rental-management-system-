namespace SDCRMS.DTOs.Notification
{
    public class NotificationDto
    {
        public int NotificationID { get; set; }
        public string Message { get; set; } = string.Empty;
        public string Title { get; set; } = string.Empty;
        public string LinkURL { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
        public bool Read { get; set; }
    }
}
