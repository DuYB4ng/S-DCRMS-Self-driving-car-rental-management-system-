namespace SDCRMS.Dtos.Car
{
    public class CreateOwnerCarDTO
    {
        public int RoleID { get; set; }
        public string Username { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public int PhoneNumber { get; set; }
        public string LastName { get; set; } = string.Empty;
        public string FirstName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Sex { get; set; } = string.Empty;
        public DateTime Birthday { get; set; }
        public string Address { get; set; } = string.Empty;
    }
}