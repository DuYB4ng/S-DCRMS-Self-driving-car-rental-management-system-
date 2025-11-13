using CustomerService.Models;

namespace CustomerService.Dtos.Customer
{
    public class UpdateCustomerDto
    {
        public int CustomerId { get; set; }
        public string FirebaseUid { get; set; } = string.Empty; 
        public string DrivingLicense { get; set; } = string.Empty;
        public DateTime LicenseIssueDate { get; set; }
        public DateTime LicenseExpiryDate { get; set; }
    }
}