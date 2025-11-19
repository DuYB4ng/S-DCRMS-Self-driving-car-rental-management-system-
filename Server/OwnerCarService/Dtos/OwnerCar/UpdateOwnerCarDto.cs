namespace OwnerCarService.Dtos.OwnerCar
{
    public class UpdateOwnerCarDTO
    {
        public string DrivingLicence { get; set; } = string.Empty;  // Có thể thay đổi giấy phép
        public DateTime LicenceIssueDate { get; set; }
        public DateTime LicenceExpiryDate { get; set; }

        public bool IsActive { get; set; } = true;       // Cho phép admin vô hiệu hóa hoặc kích hoạt
    }
}
