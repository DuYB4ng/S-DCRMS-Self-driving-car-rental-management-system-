namespace SDCRMS.Dtos.Staff
{
    public class StaffDto
    {
        public int StaffId { get; set; }
        public string FirebaseUid { get; set; } = null!;
        public string FullName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string PhoneNumber { get; set; } = null!;
        public string Sex { get; set; } = null!;
        public string Address { get; set; } = null!;
        public string Position { get; set; } = null!;
        public DateTime HireDate { get; set; }
        public string Status { get; set; } = "Active";
    }
}
