namespace SDCRMS.DTOs.Admin
{
    public class AdminDto
    {
        public int UserID { get; set; }
        public string Role { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string FirstName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;
        public string Sex { get; set; } = string.Empty;
        public DateTime Birthday { get; set; }
        public string Address { get; set; } = string.Empty;
        public DateTime JoinDate { get; set; }
    }
}
