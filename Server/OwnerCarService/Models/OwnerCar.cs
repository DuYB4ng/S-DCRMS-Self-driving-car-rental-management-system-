namespace OwnerCarService.Models
{
    public class OwnerCar
    {
        public int OwnerCarId { get; set; }
        public int UserId { get; set; }     // Liên kết đến UserService
        public string DrivingLicence { get; set; } = string.Empty;
        public DateTime LicenceIssueDate { get; set; }
        public DateTime LicenceExpiryDate { get; set; }

        // Danh sách xe thuộc sở hữu của chủ xe
        public List<Car> Cars { get; set; } = new List<Car>();

        // Trạng thái hoạt động
        public bool IsActive { get; set; } = true;

        // Theo dõi thời gian tạo và cập nhật
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? UpdatedAt { get; set; }
    }
}
