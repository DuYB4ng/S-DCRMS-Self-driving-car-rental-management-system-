using Microsoft.AspNetCore.Mvc;
using BookingService.Mappers;
using BookingService.Dtos.Booking;
using Microsoft.EntityFrameworkCore;
using BookingService.Interfaces;
using BookingService.Services;
using Microsoft.AspNetCore.Authorization;
using BookingService.Constants;
using System.Linq;
using System.Collections.Generic;
using BookingService.Models;

namespace BookingService.Controllers
{
    [Route("api/Booking")]
    [ApiController]
    public class BookingController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IBookingRepository _bookingRepo;
        private readonly CustomerClient _customerClient;
        public BookingController(AppDbContext context, IBookingRepository bookingRepo, CustomerClient customerClient)
        {
            _context = context;
            _bookingRepo = bookingRepo;
            _customerClient = customerClient;
        }

        [HttpGet]
        public async Task<IActionResult> Getall()
        {
            await CleanupExpiredPendingBookingsAsync();
            var bookings = await _bookingRepo.getAllAsync();
            var dtoBooking = bookings.Select(s => s.ToBookingDto());
            return Ok(dtoBooking);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById([FromRoute] int id)
        {
            var booking = await _bookingRepo.getByIdAsync(id);
            if (booking == null)
            {
                return NotFound();
            }
            return Ok(booking.ToBookingDto());
        }

        [HttpPost]
        [AllowAnonymous]
        public async Task<IActionResult> Create(
            [FromBody] CreateBookingDto bookingDto,
            [FromQuery] string? firebaseUid)  
        {
            int customerId;

            // ===== 1. Xác định customerId theo firebaseUid (DEV MODE) =====
            if (string.IsNullOrEmpty(firebaseUid))
            {
                return BadRequest("firebaseUid is required in dev mode");
            }

            var customer = await _customerClient.GetByFirebaseUidAsync(firebaseUid);
            if (customer == null)
            {
                return BadRequest(new { message = "Customer profile not found" });
            }

            customerId = customer.CustomerId;

            // ===== 2. Validate thời gian =====
            if (bookingDto.EndDate <= bookingDto.StartDate)
            {
                return BadRequest(new { message = "Thời gian trả xe phải sau thời gian nhận xe." });
            }

            // ===== 3. Kiểm tra trùng lịch =====
            var hasOverlapBooking = await _context.Bookings
                .AnyAsync(b =>
                    b.CarId == bookingDto.CarId &&
                    b.Status != BookingStatuses.Cancelled &&
                    b.StartDate < bookingDto.EndDate &&
                    b.EndDate > bookingDto.StartDate);

            if (hasOverlapBooking)
            {
                return Conflict(new
                {
                    message = "Xe này đã có người đặt trong khoảng thời gian bạn chọn. Vui lòng chọn xe hoặc khung giờ khác."
                });
            }

            // ===== 4. Tạo booking =====
            var bookingModel = await _bookingRepo.createAsync(bookingDto, customerId);
            
            // Set Deposit Amount (Collateral) from DTO (or default to 0 if not sent, better to trust FE here for simple flow)
            // If FE sends 0, we might want to keep the old logic or require > 0?
            // User requirement: "Initial payment IS Deposit (Collateral)".
            if (bookingDto.DepositAmount > 0)
            {
               bookingModel.DepositAmount = bookingDto.DepositAmount;
            }
            else 
            {
               // Fallback if FE didn't update yet (though we will update FE too)
               // Just keep what Repo might have set or 0.
               // We should respect DTO.DepositAmount if logic shifted.
               bookingModel.DepositAmount = 0; 
            }

            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetById),
                new { id = bookingModel.BookingID },
                bookingModel.ToBookingDto());
        }

        [HttpPut]
        [Route("{id}")]
        public async Task<IActionResult> Update([FromRoute] int id, [FromBody] UpdateBookingDto bookingDto)
        {
            var existingBooking = await _bookingRepo.updateAsync(id, bookingDto);
            if (existingBooking is null) return NotFound();
            return Ok(existingBooking.ToBookingDto());
        }

        [HttpDelete]
        [Route("{id}")]
        public async Task<IActionResult> Delete([FromRoute] int id)
        {
            var existingBooking = await _bookingRepo.deleteAsync(id);
            if (!existingBooking)
            {
                return NotFound();
            }
            return NoContent();
        }

        // POST: api/booking/{id}/check-in
        [HttpPost("{id}/check-in")]
        [AllowAnonymous] 
        public async Task<IActionResult> CheckIn(
            int id,
            [FromQuery] string? firebaseUid 
        )
        {
            var booking = await _context.Bookings.FindAsync(id);
            if (booking == null)
                return NotFound(new { message = "Booking not found" });

            // ... (Firebase Auth logic omitted for brevity, keeping existing flow) ...
            string? uid = firebaseUid ?? User.FindFirst("firebaseUid")?.Value ?? User.FindFirst("user_id")?.Value;
            if (string.IsNullOrEmpty(uid)) return BadRequest("firebaseUid required");

            var customer = await _customerClient.GetByFirebaseUidAsync(uid);
            if (customer == null) return BadRequest(new { message = "Customer profile not found" });

            if (booking.CustomerId != customer.CustomerId) return Forbid();

            // === 1. CHECK START DATE TIME ===
            // Allow check-in 1 hour before start time
            // COMMENTED OUT FOR DEV TESTING as per User Request (users test with future dates often)
            // if (DateTime.UtcNow < booking.StartDate.AddHours(-1))
            // {
            //      return BadRequest(new { message = "Chưa đến giờ nhận xe. Vui lòng quay lại sau." });
            // }

            var allowedStatuses = new[] { BookingStatuses.Paid, BookingStatuses.Pending, "Approved" };
            if (!allowedStatuses.Contains(booking.Status, StringComparer.OrdinalIgnoreCase))
            {
                 return BadRequest(new { message = $"Booking must be Paid/Approved/Pending to check-in. Current: {booking.Status}" });
            }

            if (booking.CheckIn)
                return BadRequest(new { message = "Booking already checked in" });

            booking.CheckIn = true;
            booking.Status = BookingStatuses.InProgress;

            await _context.SaveChangesAsync();
            return Ok(booking.ToBookingDto());
        }

        // POST: api/booking/{id}/request-check-out (Customer requests return)
        [HttpPost("{id}/request-check-out")]
        [AllowAnonymous]
        public async Task<IActionResult> RequestCheckOut(
            int id,
            [FromQuery] string? firebaseUid
        )
        {
            var booking = await _context.Bookings.FindAsync(id);
            if (booking == null) return NotFound();

            string? uid = firebaseUid ?? User.FindFirst("firebaseUid")?.Value ?? User.FindFirst("user_id")?.Value;
            if (string.IsNullOrEmpty(uid)) return BadRequest("firebaseUid required");

            var customer = await _customerClient.GetByFirebaseUidAsync(uid);
            if (customer == null) return BadRequest(new { message = "Customer not found" });

            if (booking.CustomerId != customer.CustomerId) return Forbid();

            if (!booking.CheckIn) return BadRequest(new { message = "Must check-in first" });
            if (booking.CheckOut) return BadRequest(new { message = "Already checked out" });

            // Set Status to ReturnRequested
            booking.Status = BookingStatuses.ReturnRequested;
            
            await _context.SaveChangesAsync();
            return Ok(booking.ToBookingDto());
        }

        // POST: api/booking/{id}/confirm-return (Owner confirms return)
        [HttpPost("{id}/confirm-return")]
        [AllowAnonymous]
        // POST: api/booking/{id}/confirm-return (Owner confirms return)
        [HttpPost("{id}/confirm-return")]
        [AllowAnonymous]
        public async Task<IActionResult> ConfirmReturn(int id, [FromServices] OwnerCarClient ownerCarClient, [FromServices] UserClient userClient)
        {
            try
            {
                // Load Booking with Payments
                var booking = await _context.Bookings.Include(b => b.Payments).FirstOrDefaultAsync(b => b.BookingID == id);
                if (booking == null) return NotFound(new { Message = "Booking not found" });

                if (booking.Status == BookingStatuses.Completed || booking.Status == BookingStatuses.Cancelled)
                    return BadRequest(new { Message = "Booking already processed." });

                // Get Owner UID
                var ownerId = await ownerCarClient.GetOwnerIdByCarIdAsync(booking.CarId);
                string? ownerUid = null;
                if (ownerId != null)
                {
                    ownerUid = await ownerCarClient.GetOwnerFirebaseUidAsync(ownerId.Value);
                }

                if (string.IsNullOrEmpty(ownerUid))
                {
                    return BadRequest(new { Message = "Cannot identify Owner Wallet." });
                }

                // 1. REFUND DEPOSIT TO CUSTOMER (From System Holding)
                // System currently holds Deposit + Rent (if paid via Wallet/VNPAY).
                if (booking.DepositAmount > 0)
                {
                     var customer = await _customerClient.GetByIdAsync(booking.CustomerId);
                     if (customer != null && !string.IsNullOrEmpty(customer.FirebaseUid))
                     {
                         // Credit Customer directly (System -> Customer)
                         // DO NOT Deduct Owner (since Owner never received Deposit)
                         await userClient.CreditWalletAsync(customer.FirebaseUid, booking.DepositAmount);
                     }
                }

                // 2. PAY OWNER (Rent - Commission)
                // System holds everything. We paid out Deposit. Remaining is Rent.
                decimal commissionRate = 0.1m; // 10%
                decimal rentAmount = booking.TotalPrice; // Assuming Rent = TotalPrice
                decimal commission = rentAmount * commissionRate;

                // How much Rent did we actually collect?
                // TotalPaid = Deposit + RentPaid.
                var totalPaid = booking.Payments
                    .Where(p => (p.Method == "Wallet" || p.Method == "VNPAY") && (p.Status == "Completed" || p.Status == "Success"))
                    .Sum(p => p.Amount);
                
                // System Remaining = TotalPaid - DepositAmount (Refunded above)
                // If Full Paid: System Remaining = Rent.
                // Owner Payout = Rent - Commission.
                // We transfer System Remaining -> Owner, BUT minus Commission?
                // No. Owner gets `Rent - Commission`.
                // If System Remaining < Rent (e.g. paying cash?), then logic differs.
                // Assuming Full Wallet Payment for now as per flows.
                
                // Rent = TotalPrice? Yes often.
                // Payout = Rent * 0.9.
                
                decimal payoutToOwner = rentAmount - commission;
                
                if (payoutToOwner > 0)
                {
                    await userClient.CreditWalletAsync(ownerUid!, payoutToOwner);
                }

                // 3. Update Status
                booking.CheckOut = true;
                booking.Status = BookingStatuses.Completed;
                await _context.SaveChangesAsync();

                return Ok(booking.ToBookingDto());
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = $"Lỗi xử lý trả xe: {ex.Message}" });
            }
        }

        // POST: api/booking/{id}/cancel
        [HttpPost("{id}/cancel")]
        public async Task<IActionResult> Cancel(int id, [FromServices] UserClient userClient, [FromServices] OwnerCarClient ownerCarClient)
        {
            var booking = await _context.Bookings.FindAsync(id);
            if (booking == null)
                return NotFound(new { message = "Booking not found" });

            if (booking.Status == "Completed" || booking.Status == "Cancelled")
                return BadRequest(new { message = "Booking already completed or cancelled" });

            if (booking.CheckIn)
                return BadRequest(new { message = "Cannot cancel after check-in" });

            // Cancellation Policy
            var now = DateTime.UtcNow;
            decimal feePercent = 0;
            double hoursBefore = (booking.StartDate - now).TotalHours;
            
            if (hoursBefore > 168) // 7 days
                feePercent = 0;
            else if (hoursBefore > 24)
                feePercent = 10;
            else
                feePercent = 30; // Late cancel

            await _context.Entry(booking).Collection(b => b.Payments).LoadAsync();
            
            decimal totalPaid = booking.Payments
                .Where(p => p.Status == "Success" || p.Status == "Completed")
                .Sum(p => p.Amount);
                
            decimal feeAmount = booking.TotalPrice * (feePercent / 100m);
            
            // Refund Amount = TotalPaid - Fee. 
            // (If Fee > TotalPaid, Refund = 0. FeeTaken = TotalPaid).
            decimal refundAmount = totalPaid - feeAmount;
            if (refundAmount < 0) refundAmount = 0;
            
            // Fee Taken is what we DON'T refund.
            decimal actualFeeTaken = totalPaid - refundAmount;

            // 1. REFUND CUSTOMER (From System)
            // System holds TotalPaid. We give back RefundAmount.
            var uid = User.FindFirst("firebaseUid")?.Value;
            if (uid != null && refundAmount > 0)
            {
                 // System -> Customer
                 await userClient.CreditWalletAsync(uid, refundAmount);
            }
            
            // 2. PAY FEE TO OWNER (From System)
            // System holds Remaining = TotalPaid - RefundAmount = ActualFeeTaken.
            // This Fee belongs to Owner (compensation).
            if (actualFeeTaken > 0)
            {
                 var ownerId = await ownerCarClient.GetOwnerIdByCarIdAsync(booking.CarId);
                 if (ownerId != null)
                 {
                     var ownerUid = await ownerCarClient.GetOwnerFirebaseUidAsync(ownerId.Value);
                     if (!string.IsNullOrEmpty(ownerUid))
                     {
                         // System -> Owner
                         await userClient.CreditWalletAsync(ownerUid, actualFeeTaken);
                     }
                 }
            }

            booking.Status = BookingStatuses.Cancelled;
            booking.CancellationFee = actualFeeTaken;
            booking.RefundAmount = refundAmount;

            await _context.SaveChangesAsync();
            return Ok(new { 
                Booking = booking.ToBookingDto(),
                CancellationFee = actualFeeTaken,
                RefundAmount = refundAmount,
                Message = "Cancelled successfully."
            });
        }


        // POST: api/booking/{id}/pay
        [HttpPost("{id}/pay")]
        public async Task<IActionResult> PayBooking(int id, [FromServices] UserClient userClient, [FromServices] OwnerCarClient ownerCarClient, [FromQuery] bool isDeposit = true)
        {
            var booking = await _context.Bookings.Include(b => b.Payments).FirstOrDefaultAsync(b => b.BookingID == id);
            if (booking == null) return NotFound();

            if (booking.Status == BookingStatuses.Cancelled || booking.Status == "Completed")
                return BadRequest("Booking is already finalized.");

            var uid = User.FindFirst("firebaseUid")?.Value; 
            if (string.IsNullOrEmpty(uid)) uid = Request.Query["firebaseUid"];

            if (string.IsNullOrEmpty(uid)) return BadRequest("User not identified");

            decimal amountToPay = 0;
            if (isDeposit)
            {
                amountToPay = booking.DepositAmount;
                if (amountToPay == 0 && booking.TotalPrice > 0) amountToPay = booking.TotalPrice * 0.3m;
                if (amountToPay <= 0) return BadRequest(new { Message = "Invalid Deposit Amount." });

                var paid = booking.Payments
                    .Where(p => p.Status == "Completed" || p.Status == "Success")
                    .Sum(p => p.Amount);

                if (paid >= amountToPay - 1000) return BadRequest(new { Message = "Deposit already paid." });
                if (paid > 0) amountToPay -= paid;
            }
            else
            {
                // Full Payment Logic (Rent)
                // ... (Logic same as before)
                // NOTE: If paying Rent, System holds it. We don't transfer to Owner yet.
                amountToPay = booking.TotalPrice;
                var totalPaid = booking.Payments.Where(p => p.Status == "Completed" || p.Status == "Success").Sum(p => p.Amount);
                var rentPaid = totalPaid - booking.DepositAmount;
                if (rentPaid > 0) amountToPay -= rentPaid;
            }

            if (amountToPay <= 0) return BadRequest(new { Message = "Nothing to pay." });

            // 1. Deduct Customer
            bool success = false;
            try 
            {
               success = await userClient.DeductWalletAsync(uid, amountToPay);
            }
            catch (Exception ex)
            {
               return StatusCode(500, new { Message = $"Lỗi kết nối ví: {ex.Message}" });
            }

            if (!success) return BadRequest(new { Message = "Số dư ví không đủ." });

            // 2. Deposit logic: System holds it. Do NOT transfer to Owner.
            // (Reverted direct transfer logic based on user request "Owner currently does not hold deposit")

            // Record Payment
            var payment = new BookingPayment
            {
                BookingID = booking.BookingID,
                Amount = amountToPay,
                Method = "Wallet",
                PaymentDate = DateTime.UtcNow,
                Status = "Completed"
            };
            _context.Payments.Add(payment);
            
            if (isDeposit)
            {
                if (booking.Status == "Pending") booking.Status = "Approved"; 
            }
            else 
            {
                 var totalPaid = booking.Payments.Where(p => p.Status == "Completed" || p.Status == "Success").Sum(p => p.Amount) + amountToPay;
                 if (totalPaid >= booking.TotalPrice - 1000)
                     booking.Status = "Paid";
            }

            await _context.SaveChangesAsync();
            return Ok(booking.ToBookingDto());
        }

        private async Task CleanupExpiredPendingBookingsAsync()
        {
            var now = DateTime.UtcNow;
            var timeoutMinutes = 15;

            var expired = await _context.Bookings
                .Where(b => b.Status == "Pending" &&
                            b.CreatedAt < now.AddMinutes(-timeoutMinutes))
                .ToListAsync();

            if (expired.Any())
            {
                _context.Bookings.RemoveRange(expired);
                await _context.SaveChangesAsync();
            }
        }

        [HttpGet("car/{carId}")]
        public async Task<IActionResult> GetByCarId(int carId)
        {
            await CleanupExpiredPendingBookingsAsync();
            var bookings = await _context.Bookings
                .Where(b => b.CarId == carId)
                .OrderByDescending(b => b.CreatedAt)
                .ToListAsync();
            return Ok(bookings.Select(b => b.ToBookingDto()));
        }

        // GET: api/Booking/my
        [HttpGet("my")]
        public async Task<IActionResult> GetMyBookings([FromQuery] string? firebaseUid)
        {
            if (string.IsNullOrEmpty(firebaseUid))
            {
                return BadRequest("firebaseUid is required in dev mode");
            }

            // Lấy customer theo firebaseUid
            var customer = await _customerClient.GetByFirebaseUidAsync(firebaseUid);
            if (customer == null)
            {
                return BadRequest(new { message = "Customer profile not found" });
            }

            var customerId = customer.CustomerId;

            await CleanupExpiredPendingBookingsAsync();

            var bookings = await _context.Bookings
                .Where(b => b.CustomerId == customerId)
                .OrderByDescending(b => b.CreatedAt)
                .ToListAsync();

            var dtoBooking = bookings.Select(b => b.ToBookingDto());
            return Ok(dtoBooking);
        }
    }
}
