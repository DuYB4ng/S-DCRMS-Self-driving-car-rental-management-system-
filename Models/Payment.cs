namespace SDCRMS.Models
{
    public class Payment
    {
        public int PaymentID { get; set; }
        public int BookingID { get; set; }
        public DateTime PaymentDate { get; set; }
        public decimal Amount { get; set; }
        public string Method { get; set; }
        public string Status { get; set; }
    }
}
