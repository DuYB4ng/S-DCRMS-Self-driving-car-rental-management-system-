using BookingService.Models;
using BookingService.Dtos.Review;

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
		public int CarId { get; set; }
		public decimal TotalPrice { get; set; }
		public decimal DepositAmount { get; set; }
		public decimal RefundAmount { get; set; }
		public decimal CancellationFee { get; set; }
		public DateTime CreatedAt { get; set; }
	}
}