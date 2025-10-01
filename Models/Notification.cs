namespace SDCRMS.Models
{
    public class Notification
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public required string Message { get; set; }
        public DateTime CreatedAt { get; set; }
        public required string title { get; set; }
        public DateTime CreateAt { get; set; }
        public bool Read { get; set; }
        public required string linkURL { get; set; }
    }
}
