namespace BookingService.VnPay
{
    public class PaymentInformationModel
    {
        public int PaymentId { get; set; } 
        public string OrderType { get; set; } = string.Empty;
        public double Amount { get; set; }
        public string OrderDescription { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
    }
}