namespace SDCRMS.Models
{
    public class OwnerCar
    {
        public int OwnerCarId { get; set; }
        public int UserId { get; set; }     // Liên kết đến UserService
        public string DrivingLicence { get; set; } = string.Empty;
        public DateTime LicenceIssueDate { get; set; }
        public DateTime LicenceExpiryDate { get; set; }

        public List<Car> Cars { get; set; } = new List<Car>();
    }

}