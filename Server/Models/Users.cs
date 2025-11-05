using SDCRMS.Models.Enums;

namespace SDCRMS.Models
{
    public class Users
    {
        public int UserID { get; set; }
        public UserRole Role { get; set; }
        public string PhoneNumber { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string FirstName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty; // Thêm mật khẩu
        public string Sex { get; set; } = string.Empty;
        public DateTime Birthday { get; set; }
        public DateTime JoinDate { get; set; }
        public string Address { get; set; } = string.Empty;
    }
}
