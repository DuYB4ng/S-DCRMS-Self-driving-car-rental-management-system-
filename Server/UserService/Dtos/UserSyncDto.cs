namespace UserService.Models
{
    public class UserSyncDto
    {
        public string FirebaseUid { get; set; } = string.Empty;
        public string Username { get; set; } = string.Empty;
        public string Role { get; set; } = "User";
        public string PhoneNumber { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string FirstName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Sex { get; set; } = string.Empty;
        public DateTime? Birthday { get; set; }
        public string Address { get; set; } = string.Empty;
    }
}
