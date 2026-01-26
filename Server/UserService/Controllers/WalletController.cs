using Microsoft.AspNetCore.Mvc;
using UserService.Dtos;
using UserService.Repositories;
using UserService.Services;
using UserService.Data;
using UserService.Models;
using UserService.VnPay;

namespace UserService.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class WalletController : ControllerBase
    {
        private readonly IUserRepository _userRepo;
        private readonly IVnPayService _vnPayService;
        private readonly AppDbContext _context;

        public WalletController(IUserRepository userRepo, IVnPayService vnPayService, AppDbContext context)
        {
            _userRepo = userRepo;
            _vnPayService = vnPayService;
            _context = context;
        }

        [HttpGet("balance")]
        public async Task<IActionResult> GetBalance([FromQuery] string firebaseUid)
        {
            var user = await _userRepo.GetByFirebaseUidAsync(firebaseUid);
            if (user == null) return NotFound("User not found");
            return Ok(new { Balance = user.WalletBalance, BankAccountNumber = user.BankAccountNumber, BankName = user.BankName });
        }

        [HttpPost("topup")]
        public async Task<IActionResult> TopUp([FromBody] WalletTransactionDto dto)
        {
            // Old simulation method, keep or update?
            // Let's keep for backward compatibility or direct admin topup.
            var user = await _userRepo.GetByFirebaseUidAsync(dto.FirebaseUid);
            if (user == null) return NotFound("User not found");

            user.WalletBalance += dto.Amount;
            if (user.WalletBalance >= 0) user.LastNegativeBalanceDate = null;

            await _userRepo.UpdateAsync(user);
            return Ok(new { NewBalance = user.WalletBalance });
        }

        [HttpPost("topup-vnpay")]
        public async Task<IActionResult> TopUpVnPay([FromBody] WalletTransactionDto dto)
        {
             try
             {
                 var user = await _userRepo.GetByFirebaseUidAsync(dto.FirebaseUid);
                 if (user == null) return NotFound("User not found");
    
                 // 1. Create Pending Transaction
                 var transaction = new WalletTransaction
                 {
                     FirebaseUid = dto.FirebaseUid,
                     Amount = dto.Amount,
                     Status = "Pending",
                     TransactionType = "TopUp",
                     Description = $"Top up wallet for user {dto.FirebaseUid}"
                 };
                 _context.WalletTransactions.Add(transaction);
                 await _context.SaveChangesAsync();
    
                 // 2. Generate URL
                 var ticks = DateTime.Now.Ticks.ToString();
                 transaction.VnPayTxnRef = ticks; 
                 await _context.SaveChangesAsync();
                 
                 var info = new PaymentInformationModel
                 {
                     OrderType = "topup",
                     Amount = (double)dto.Amount,
                     OrderDescription = $"TopUp Wallet {transaction.Id}",
                     Name = "User Wallet",
                     OrderId = transaction.Id.ToString()
                 };
                 
                 // Generate URL (Wrapped in try-catch inside Service too, but just in case)
                 var url = _vnPayService.CreatePaymentUrl(info, HttpContext);
                 
                 return Ok(new { paymentUrl = url });
             }
             catch (Exception ex)
             {
                 Console.WriteLine($"Error in TopUpVnPay: {ex}");
                 return BadRequest(new { Message = $"Lỗi Server: {ex.Message}" });
             }
        }
        
        [HttpGet("vnpay-return")]
        public async Task<IActionResult> VnPayReturn()
        {
             var response = _vnPayService.PaymentExecute(Request.Query);
             if (!response.Success) return BadRequest("Invalid Signature");

             if (response.VnPayResponseCode == "00")
             {
                 // Extract ID from TxnRef
                 if (int.TryParse(response.OrderId, out int transId))
                 {
                     var trans = await _context.WalletTransactions.FindAsync(transId);
                     if (trans != null && trans.Status == "Pending")
                     {
                         trans.Status = "Completed";
                         trans.UpdatedAt = DateTime.UtcNow;
                         
                         // Update User Wallet
                         var user = await _userRepo.GetByFirebaseUidAsync(trans.FirebaseUid);
                         if (user != null)
                         {
                             user.WalletBalance += trans.Amount;
                             if (user.WalletBalance >= 0) user.LastNegativeBalanceDate = null;
                             await _userRepo.UpdateAsync(user);
                         }
                         await _context.SaveChangesAsync();
                         
                         return Content("<html><body style='text-align:center; padding-top:50px;'><h1>Giao dịch thành công!</h1><p>Số dư ví đã được cập nhật.</p><p>Bạn có thể đóng cửa sổ này.</p></body></html>", "text/html");
                     }
                 }
                 else 
                 {
                      return Content("<html><body><h1>Giao dịch thành công nhưng không tìm thấy mã giao dịch!</h1></body></html>", "text/html");
                 }
             }
             else 
             {
                 return Content("<html><body><h1>Giao dịch thất bại!</h1></body></html>", "text/html");
             }
             
             return Ok("Processed");
        }

        [HttpPost("deduct")]
        public async Task<IActionResult> Deduct([FromBody] WalletTransactionDto dto)
        {
            var user = await _userRepo.GetByFirebaseUidAsync(dto.FirebaseUid);
            if (user == null) return NotFound("User not found");

            user.WalletBalance -= dto.Amount;

            // Check if balance went negative and it wasn't before
            if (user.WalletBalance < 0 && user.LastNegativeBalanceDate == null)
            {
                user.LastNegativeBalanceDate = DateTime.UtcNow;
            }

            await _userRepo.UpdateAsync(user);
            return Ok(new { NewBalance = user.WalletBalance });
        }

        [HttpPost("withdraw")]
        public async Task<IActionResult> Withdraw([FromBody] WalletTransactionDto dto)
        {
            var user = await _userRepo.GetByFirebaseUidAsync(dto.FirebaseUid);
            if (user == null) return NotFound(new { Message = "User not found" });

            if (user.WalletBalance < dto.Amount)
            {
                return BadRequest(new { Message = "Số dư không đủ để rút." });
            }

            user.WalletBalance -= dto.Amount;
            
            // Log transaction
             var transaction = new WalletTransaction
             {
                 FirebaseUid = dto.FirebaseUid,
                 Amount = dto.Amount,
                 Status = "Completed",
                 TransactionType = "Withdraw",
                 Description = "Withdraw from wallet"
             };
             _context.WalletTransactions.Add(transaction);
             await _context.SaveChangesAsync();
            
            await _userRepo.UpdateAsync(user);
            return Ok(new { NewBalance = user.WalletBalance, Message = "Rút tiền thành công!" });
        }

        [HttpPost("update-bank")]
        public async Task<IActionResult> UpdateBank([FromBody] UpdateBankDto dto)
        {
            var user = await _userRepo.GetByFirebaseUidAsync(dto.FirebaseUid);
            if (user == null) return NotFound("User not found");

            user.BankAccountNumber = dto.BankAccountNumber;
            user.BankName = dto.BankName;

            await _userRepo.UpdateAsync(user);
            return Ok(new { Message = "Bank info updated" });
        }

        [HttpGet("negative-owners")]
        public async Task<IActionResult> GetNegativeOwners()
        {
            var threshold = DateTime.UtcNow.AddDays(-3);
            var users = await _userRepo.GetUsersWithNegativeBalanceAsync(threshold);
            return Ok(users);
        }
    }
}
