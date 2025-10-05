
namespace SDCRMS.DTOs.Admin
{
    public class CreateAdminDto
    {
        public int RoleID { get; set; }
        public string LastName { get; set; } = string.Empty;
        public string FirstName { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public int PhoneNumber { get; set; }
        public string Sex { get; set; } = string.Empty;
        public DateTime Birthday { get; set; }
        public string Address { get; set; } = string.Empty;
        public DateTime JoinedAt { get; set; }

        internal Models.Admin ToAdmin()
        {
            throw new NotImplementedException();
        }
    }
}
