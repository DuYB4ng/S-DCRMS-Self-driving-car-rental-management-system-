using BookingService.Models;

namespace BookingService.Dtos.Booking
{
    public class CreateBookingDto
    {
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int CarId { get; set; }
        public decimal TotalPrice { get; set; }
        public decimal DepositAmount { get; set; }
    }
}