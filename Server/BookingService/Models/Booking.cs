using System.Collections.Generic;

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
        public List<BookingPayment> Payments { get; set; } = new List<BookingPayment>();
        public string Status { get; set; } = "Pending";
        public int CustomerId { get; set; }
        public int CarId { get; set; }
        public decimal TotalPrice { get; set; }
        public decimal DepositAmount { get; set; }
        public decimal RefundAmount { get; set; }
        public decimal CancellationFee { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}