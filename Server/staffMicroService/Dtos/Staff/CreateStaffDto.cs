namespace SDCRMS.Dtos.Staff
{
    public class CreateStaffDto
    {
        public string Username { get; set; }
        public string Password { get; set; } // chỉ dùng khi register
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Sex { get; set; }
        public string PhoneNumber { get; set; }
        public string Address { get; set; }

    }
}
