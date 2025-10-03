namespace SDCRMS.Models
{
    public class Users
    {
        public int UserID { get; set; }
        public int RoleID { get; set; }
        public int PhoneNumber { get; set; }
        public string LastName { get; set; } = string.Empty;
        public string FirstName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Sex { get; set; } = string.Empty;
        public DateTime Birthday { get; set; }
        public DateTime JoinDate { get; set; }
        public string Address { get; set; } = string.Empty;
    }
}
