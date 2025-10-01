namespace SDCRMS.Models
{
    public class OwnerCar : Users
    {
        public int OwnerID { get; set; }
        public string DrivingLisence { get; set; } = string.Empty;
        public DateTime LisenceIssueDate { get; set; }
        public DateTime LisenceExpiryDate { get; set; }
    }
}
