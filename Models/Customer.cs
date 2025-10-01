using System.Threading.Tasks;

namespace SDCRMS.Models
{
    public class Customer : Users
    {
        public int CustomerID { get; set; }
        public string DrivingLisence { get; set; } = string.Empty;
        public DateTime LisenceIssueDate { get; set; }
        public DateTime LisenceExpiryDate { get; set; }
    }
}
