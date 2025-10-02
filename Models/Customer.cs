using System.Threading.Tasks;

namespace SDCRMS.Models
{
    public class Customer : Users
    {
        public string DrivingLicense { get; set; } = string.Empty;
        public DateTime LicenseIssueDate { get; set; }
        public DateTime LicenseExpiryDate { get; set; }
        public List<Booking> Bookings { get; set; } = new List<Booking>();
    }
}
