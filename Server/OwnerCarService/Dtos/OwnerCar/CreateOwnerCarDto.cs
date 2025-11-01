namespace SDCRMS.Dtos.OwnerCar
{
    public class CreateOwnerCarDTO
    {
        public int UserId { get; set; }             // ID từ UserService
        public string DrivingLicence { get; set; } = string.Empty;
        public DateTime LicenceIssueDate { get; set; }
        public DateTime LicenceExpiryDate { get; set; }
    }
}
