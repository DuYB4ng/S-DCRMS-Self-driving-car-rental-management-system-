namespace SDCRMS.Models
{
    public class Customer : Users
    {
        public string DrivingLisence { get; set; }
        public DateTime LisenceIssueDate { get; set; }
        public DateTime LisenceExpiryDate { get; set; }
    }
}
