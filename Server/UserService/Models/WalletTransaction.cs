using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UserService.Models
{
    public class WalletTransaction
    {
        public int Id { get; set; }
        
        [Required]
        public string FirebaseUid { get; set; }
        
        [Column(TypeName = "decimal(18, 2)")]
        public decimal Amount { get; set; }
        
        // Pending, Completed, Failed
        public string Status { get; set; } = "Pending";
        
        public string TransactionType { get; set; } // "TopUp", "Withdraw", "Commission"
        
        public string? VnPayTxnRef { get; set; } // Only for VNPAY
        public string? Description { get; set; }
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? UpdatedAt { get; set; }
    }
}
