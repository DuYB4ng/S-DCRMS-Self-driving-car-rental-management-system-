using System.Threading.Tasks;
using System.Collections.Generic;
using System;
using SDCRMS.Models.Enums;
namespace SDCRMS.Models
{
    public class Customer : Users
    {
        public Customer() => Role = UserRole.Customer;
        public string DrivingLicense { get; set; } = string.Empty;
        public DateTime LicenseIssueDate { get; set; }
        public DateTime LicenseExpiryDate { get; set; }
        public List<Booking> Bookings { get; set; } = new List<Booking>();
    }
}
