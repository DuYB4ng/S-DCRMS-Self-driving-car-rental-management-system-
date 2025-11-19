using System.ComponentModel.DataAnnotations;

namespace SDCRMS.Models
{
    public class FCMToken
    {
        [Key]
        public int TokenID { get; set; }

        [Required]
        public int UserID { get; set; }

        [Required]
        [MaxLength(500)]
        public string Token { get; set; } = string.Empty;

        [Required]
        [MaxLength(50)]
        public string DeviceType { get; set; } = string.Empty; // "Android", "iOS", "Web"

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public DateTime? LastUsedAt { get; set; }

        public bool IsActive { get; set; } = true;
    }
}
