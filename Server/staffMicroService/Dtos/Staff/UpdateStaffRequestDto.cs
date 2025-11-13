namespace SDCRMS.Dtos.Staff
{
    public class UpdateStaffRequestDto
    {
        public string? FullName { get; set; }       // Thay thế cho FirstName + LastName
        public string? Email { get; set; }
        public string? PhoneNumber { get; set; }
        public string? Address { get; set; }
        public string? Position { get; set; }       // Chức vụ (Staff, Leader, ...)
        public string? Status { get; set; }         // Active, Inactive, OnLeave
    }
}
