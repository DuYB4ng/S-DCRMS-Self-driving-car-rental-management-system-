namespace SDCRMS.Dtos.Staff
{
    public class CreateStaffDto
    {
        // 🔗 UID Firebase (nếu có)
        public string? FirebaseUid { get; set; }

        // 👤 Thông tin cá nhân
        public string FullName { get; set; } = null!;
        public string? Email { get; set; }
        public string? PhoneNumber { get; set; }
        public string? Address { get; set; }

        // 💼 Thông tin công việc
        public string? Position { get; set; } = "Staff";
    }
}
