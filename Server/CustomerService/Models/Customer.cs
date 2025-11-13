using System.Threading.Tasks;

namespace CustomerService.Models
{
    public class Customer
    {
        public int CustomerId { get; set; }
        public string FirebaseUid { get; set; } = string.Empty; 
        public string DrivingLicense { get; set; } = string.Empty;
        public DateTime LicenseIssueDate { get; set; }
        public DateTime LicenseExpiryDate { get; set; }
    }
}