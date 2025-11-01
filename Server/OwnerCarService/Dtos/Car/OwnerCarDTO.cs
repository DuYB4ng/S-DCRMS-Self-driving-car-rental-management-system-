using SDCRMS.Dtos.Car;

namespace SDCRMS.Dtos.OwnerCar
{
    public class OwnerCarDTO
    {
        public int OwnerCarId { get; set; }
        public int UserId { get; set; }     // ID người dùng từ UserService
        public string DrivingLicence { get; set; } = string.Empty;
        public DateTime LicenceIssueDate { get; set; }
        public DateTime LicenceExpiryDate { get; set; }

        public List<CarDTO>? Cars { get; set; } = new();
    }
}
