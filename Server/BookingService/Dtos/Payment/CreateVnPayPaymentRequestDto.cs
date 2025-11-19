namespace BookingService.Dtos.Payment
{
    public class CreateVnPayPaymentRequestDto
    {
        public int BookingID { get; set; }
        public decimal Amount { get; set; }
    }
}