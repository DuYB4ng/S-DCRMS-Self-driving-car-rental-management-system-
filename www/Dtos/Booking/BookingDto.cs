using SDCRMS.Models;

namespace SDCRMS.Dtos.Booking
{
    public class BookingDto
    {
        public int BookingID { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public bool CheckIn { get; set; }
        public bool CheckOut { get; set; }
    }
}
