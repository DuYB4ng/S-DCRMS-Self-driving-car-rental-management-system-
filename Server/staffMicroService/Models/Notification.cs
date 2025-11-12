namespace SDCRMS.Models
{
    public class Notification
    {
        public int Id { get; set; }
        public string Message { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public string Title { get; set; }
        public bool Read { get; set; }
        public string linkURL { get; set; }

    }
}
