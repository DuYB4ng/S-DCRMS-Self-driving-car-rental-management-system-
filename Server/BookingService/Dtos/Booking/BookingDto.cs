using BookingService.Models;

namespace BookingService.Dtos.Booking
{
	public class BookingDto
	{
		public int BookingID { get; set; }
		public DateTime StartDate { get; set; }
		public DateTime EndDate { get; set; }
		public bool CheckIn { get; set; }
		public bool CheckOut { get; set; }
		public string Status { get; set; } = string.Empty;
		public int CustomerId { get; set; }
	}
}