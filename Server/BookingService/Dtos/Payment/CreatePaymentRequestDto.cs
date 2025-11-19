using BookingService.Models;

namespace BookingService.Dtos.Payment
{
    public  class CreatePaymentRequestDto
    {
        public DateTime PaymentDate { get; set; }
        public decimal Amount { get; set; }
        public string Method { get; set; }
        public string Status { get; set; }
        public int BookingID { get; set; }
   
    }
}