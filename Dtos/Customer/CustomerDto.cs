using SDCRMS.Models;

namespace SDCRMS.Dtos.Customer
{
    public class CustomerDto
    {
        public int ID { get; set; }
        public string Username { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public int PhoneNumber { get; set; }
        public string Address { get; set; }
        public string DrivingLicense { get; set; }
        public DateTime LisenceExpiryDate { get; set; }
        public DateTime JoinDate { get; set; }
    }
}
