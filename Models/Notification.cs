namespace SDCRMS.Models
{
    public class Notification
    {
        public int NotificationID { get; set; }
        public int UserID { get; set; }
        public required string Message { get; set; }
        public DateTime CreatedAt { get; set; }
        public required string Title { get; set; }
        public bool Read { get; set; }
        public required string LinkURL { get; set; }
    }
}
