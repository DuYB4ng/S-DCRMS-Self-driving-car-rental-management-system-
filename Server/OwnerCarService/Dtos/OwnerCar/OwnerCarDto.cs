using OwnerCarService.Dtos.Car;
namespace OwnerCarService.Dtos.OwnerCar
{
    public class OwnerCarDTO
    {
        public int OwnerCarId { get; set; }
        public string firebaseUid { get; set; }     // ID người dùng từ UserService
        public string DrivingLicence { get; set; } = string.Empty;
        public DateTime LicenceIssueDate { get; set; }
        public DateTime LicenceExpiryDate { get; set; }

        // Danh sách xe thuộc chủ xe
        public List<CarDTO>? Cars { get; set; } = new();

        // quản lý trạng thái và thời gian
        public bool IsActive { get; set; } = true;
        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
    }
}
