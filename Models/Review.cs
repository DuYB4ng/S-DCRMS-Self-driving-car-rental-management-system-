namespace SDCRMS.Models
{
    public class Review
    {
        public int ReviewID { get; set; }
        public int BookingID { get; set; }
        public int Rating { get; set; }
        public required string Comment { get; set; }
        public DateTime ReviewDate { get; set; }
    }
}
