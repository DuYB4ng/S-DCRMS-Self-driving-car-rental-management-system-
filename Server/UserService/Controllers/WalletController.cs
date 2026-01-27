using Microsoft.AspNetCore.Mvc;
using UserService.Dtos;
using UserService.Repositories;
using UserService.Services;
using UserService.Data;
using UserService.Models;
using UserService.VnPay;
using Microsoft.EntityFrameworkCore;

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
                     OrderId = transaction.VnPayTxnRef // Use the Unique Ticks string to prevent duplication
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

             string title = "Giao dịch thất bại";
             string message = $"Mã lỗi: {response.VnPayResponseCode}";
             string icon = "❌";
             string color = "#e74c3c"; // Red

             if (response.VnPayResponseCode == "00")
             {
                 // Extract Transaction by VnPayTxnRef (which is passed as OrderId)
                 // response.OrderId holds the VnPayTxnRef we sent
                 var txnRef = response.OrderId;
                 
                 var trans = await _context.WalletTransactions
                                     .FirstOrDefaultAsync(t => t.VnPayTxnRef == txnRef);

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
                      
                     title = "Giao dịch thành công!";
                     message = "Số dư ví của bạn đã được cập nhật.";
                     icon = "✅";
                     color = "#2ecc71"; // Green
                 }
                 else if (trans != null && trans.Status == "Completed")
                 {
                     title = "Giao dịch đã hoàn tất";
                     message = "Giao dịch này đã được ghi nhận trước đó.";
                     icon = "ℹ️";
                     color = "#3498db"; // Blue
                 }
             }
             else 
             {
                 // Failed logic
                 var txnRef = response.OrderId;
                 var trans = await _context.WalletTransactions.FirstOrDefaultAsync(t => t.VnPayTxnRef == txnRef);
                 if (trans != null) 
                 {
                     trans.Status = "Failed";
                     await _context.SaveChangesAsync();
                 }
             }
             
             string html = $@"
                <!DOCTYPE html>
                <html lang='vi'>
                <head>
                    <meta charset='UTF-8'>
                    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
                    <title>{title}</title>
                    <style>
                        body {{ font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f6f8; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }}
                        .card {{ background: white; padding: 40px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); text-align: center; max-width: 400px; width: 90%; }}
                        .icon {{ font-size: 64px; margin-bottom: 20px; }}
                        h1 {{ color: #333; margin-bottom: 10px; font-size: 24px; }}
                        p {{ color: #666; font-size: 16px; line-height: 1.5; }}
                        .btn {{ display: inline-block; margin-top: 20px; padding: 10px 20px; background-color: {color}; color: white; text-decoration: none; border-radius: 6px; font-weight: bold; }}
                        .btn:hover {{ opacity: 0.9; }}
                    </style>
                </head>
                <body>
                    <div class='card'>
                        <div class='icon'>{icon}</div>
                        <h1>{title}</h1>
                        <p>{message}</p>
                        <p style='font-size: 14px; color: #999;'>Bạn có thể quay lại ứng dụng để kiểm tra số dư.</p>
                        <a href='selfdrivingcar://wallet' class='btn'>Quay lại ứng dụng</a>
                    </div>
                </body>
                </html>";

             return Content(html, "text/html");
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
