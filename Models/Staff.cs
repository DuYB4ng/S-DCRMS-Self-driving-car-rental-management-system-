using SDCRMS.Models.Enums;
namespace SDCRMS.Models
{
    public class Staff : Users
    {
        public Staff() => Role = UserRole.Staff;
    }
}
