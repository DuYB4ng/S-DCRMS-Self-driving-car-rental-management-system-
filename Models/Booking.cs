namespace SDCRMS.Models
{
    public class Booking
    {
        public int BookingID { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public bool CheckIn { get; set; }
        public bool CheckOut { get; set; }
        public List<Review> Reviews { get; set; } = new List<Review>();
        public Payment? Payment { get; set; }
    }
}
