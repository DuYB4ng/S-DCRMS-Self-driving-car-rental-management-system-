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

    }
}
