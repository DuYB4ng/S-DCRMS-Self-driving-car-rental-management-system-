namespace BookingService.Dtos.Booking
{
    public class UpdateBookingDto
    {
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public bool CheckIn { get; set; }
        public bool CheckOut { get; set; }
        public string Status { get; set; }
        public int CarId { get; set; }
    }
}