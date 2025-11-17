using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SDCRMS.Models
{
    [Table("Staff")] // đặt tên bảng cố định
    public class Staff
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int StaffId { get; set; }

        
        [Required]
        [MaxLength(128)]
        public string FirebaseUid { get; set; } = null!;

       
        [Required]
        [MaxLength(100)]
        public string FullName { get; set; } = null!;

        [EmailAddress]
        [MaxLength(100)]
        public string? Email { get; set; }

        [Phone]
        [MaxLength(20)]
        public string? PhoneNumber { get; set; }

        [MaxLength(100)]
        public string? Position { get; set; }     // Chức vụ: Nhân viên, Trưởng nhóm...

        [MaxLength(255)]
        public string? Address { get; set; }

       
        [Column(TypeName = "datetime2")]
        public DateTime HireDate { get; set; } = DateTime.UtcNow;

        [Column(TypeName = "datetime2")]
        public DateTime? LastActive { get; set; }

        
        [Required]
        [MaxLength(50)]
        public string Status { get; set; } = "Active";  // Active, Inactive, OnLeave

       
        public int TotalReportsHandled { get; set; } = 0;

       
    }
}
