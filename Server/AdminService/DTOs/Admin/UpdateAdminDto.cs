using System.ComponentModel.DataAnnotations;

namespace SDCRMS.DTOs.Admin
{
    public class UpdateAdminDto
    {
        [StringLength(50, ErrorMessage = "Họ không được vượt quá 50 ký tự")]
        public string LastName { get; set; } = string.Empty;

        [StringLength(50, ErrorMessage = "Tên không được vượt quá 50 ký tự")]
        public string FirstName { get; set; } = string.Empty;

        [Phone(ErrorMessage = "Số điện thoại không hợp lệ")]
        public string PhoneNumber { get; set; } = string.Empty;

        [EmailAddress(ErrorMessage = "Email không hợp lệ")]
        public string Email { get; set; } = string.Empty;

        public string Sex { get; set; } = string.Empty;
        public DateTime Birthday { get; set; }

        [StringLength(200, ErrorMessage = "Địa chỉ không được vượt quá 200 ký tự")]
        public string Address { get; set; } = string.Empty;
    }
}
