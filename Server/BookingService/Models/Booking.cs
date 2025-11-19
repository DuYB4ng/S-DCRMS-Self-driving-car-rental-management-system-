namespace BookingService.Models
{
    public class Booking
    {
        public int BookingID { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public bool CheckIn { get; set; } = false;
        public bool CheckOut { get; set; } = false;
        public List<Review> Reviews { get; set; } = new List<Review>();
        public Payment? Payment { get; set; }
        public string Status { get; set; } = "Pending";
        public int CustomerId { get; set; }
    }
}