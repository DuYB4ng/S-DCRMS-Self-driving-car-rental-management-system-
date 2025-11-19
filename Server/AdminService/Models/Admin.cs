using SDCRMS.Models.Enums;

namespace SDCRMS.Models
{
    public class Admin : Users
    {
        public Admin()
        {
            Role = UserRole.Admin;
        }
    }
}
