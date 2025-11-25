namespace SDCRMS.Models
{
    public class Review
    {
        public int ReviewID { get; set; }
        public int BookingID { get; set; }
        public int Rating { get; set; }
        public string Comment { get; set; } = string.Empty;
        public DateTime ReviewDate { get; set; }
    }
}

