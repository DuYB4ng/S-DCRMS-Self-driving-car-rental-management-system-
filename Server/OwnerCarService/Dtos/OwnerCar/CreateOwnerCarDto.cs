namespace OwnerCarService.Dtos.OwnerCar
{
    public class CreateOwnerCarDTO
    {
        public string firebaseUid { get; set; }             // ID từ UserService
        public string DrivingLicence { get; set; } = string.Empty;
        public DateTime LicenceIssueDate { get; set; }
        public DateTime LicenceExpiryDate { get; set; }
    }
}
