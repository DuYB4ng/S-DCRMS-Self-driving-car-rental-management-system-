using paymentServices.Models;

namespace paymentServices.Dtos.Payment
{
    public class UpdatePaymentRequestDto
    {
        public int PaymentID { get; set; }
        public DateTime PaymentDate { get; set; }
        public decimal Amount { get; set; }
        public string Method { get; set; }
        public string Status { get; set; }
        public int BookingID { get; set; }
   
    }
}
