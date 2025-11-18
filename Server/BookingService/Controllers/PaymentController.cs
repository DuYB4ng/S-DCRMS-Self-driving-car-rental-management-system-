using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BookingService.Models;
using System.Threading.Tasks;
using System.Linq;
using BookingService.Interfaces;
using BookingService.Dtos.Payment;
using BookingService.Mappers;
using BookingService.Services;

namespace BookingService.Controllers
{
    [Route("api/payment")]
    [ApiController]
    public class PaymentController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IPaymentRepository _paymentRepo;
        private readonly VNPayService _vnPayService;

        public PaymentController(
            AppDbContext context,
            IPaymentRepository paymentRepo,
            VNPayService vnPayService)
        {
            _context = context;
            _paymentRepo = paymentRepo;
            _vnPayService = vnPayService;
        }

        // GET: api/payment
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var payments = await _paymentRepo.GetAllAsync();
            return Ok(payments);
        }

        // GET: api/payment/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetID([FromRoute] int id)
        {
            var payment = await _paymentRepo.GetByIdAsync(id);
            if (payment == null)
            {
                return NotFound();
            }

            return Ok(payment);
        }

        [HttpPost]
        public async Task<IActionResult> TaoPayment([FromBody] CreatePaymentRequestDto payDto)
        {
            var paymentModel = payDto.ToPaymentFromCreateDto();
            await _paymentRepo.CreateAsync(paymentModel);

            // nếu method = Cash & status = Completed → coi như đã thanh toán
            var booking = await _context.Bookings.FindAsync(paymentModel.BookingID);
            if (booking != null && paymentModel.Status == "Completed")
            {
                booking.Status = "Paid";
                await _context.SaveChangesAsync();
            }

            return CreatedAtAction(nameof(GetID),
                new { id = paymentModel.PaymentID },
                paymentModel.toPaymentDto());
        }


        // PUT: api/payment/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(
            [FromRoute] int id,
            [FromBody] UpdatePaymentRequestDto updateDto)
        {
            var paymentModel = await _paymentRepo.UpdateAsync(id, updateDto);
            if (paymentModel == null)
            {
                return NotFound();
            }

            await _context.SaveChangesAsync();
            return Ok(paymentModel.toPaymentDto());
        }

        // DELETE: api/payment/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete([FromRoute] int id)
        {
            var paymentModel = await _paymentRepo.DeleteAsync(id);
            if (paymentModel == null)
            {
                return NotFound();
            }

            return NoContent();
        }

                // POST: api/payment/create-vnpay  (tạo payment + URL VNPay)
        [HttpPost("create-vnpay")]
        public async Task<IActionResult> CreateVnPayPayment([FromBody] CreateVnPayPaymentRequestDto dto)
        {
            // kiểm tra booking tồn tại
            var booking = await _context.Bookings.FirstOrDefaultAsync(b => b.BookingID == dto.BookingID);
            if (booking == null)
            {
                return NotFound(new { message = "Booking not found" });
            }

            var payment = new Payment
            {
                PaymentDate = DateTime.UtcNow,
                Amount = dto.Amount,
                Method = "VNPAY",
                Status = "Pending",
                BookingID = dto.BookingID
            };

            await _paymentRepo.CreateAsync(payment); // sau khi lưu sẽ có PaymentID

            var paymentUrl = _vnPayService.CreatePaymentUrl(payment, HttpContext);

            return Ok(new
            {
                paymentId = payment.PaymentID,
                paymentUrl,
                status = payment.Status
            });
        }

        [HttpGet("vnpay-ipn")]
        public async Task<IActionResult> VnPayIpn()
        {
            var validation = _vnPayService.ValidateIpn(Request.Query);

            if (validation.RspCode != "00")
            {
                return Ok(new { RspCode = validation.RspCode, Message = validation.Message });
            }

            if (!int.TryParse(validation.OrderId, out var paymentId))
            {
                return Ok(new { RspCode = "01", Message = "Invalid order id" });
            }

            var payment = await _paymentRepo.GetByIdAsync(paymentId);
            if (payment == null)
            {
                return Ok(new { RspCode = "01", Message = "Order not found" });
            }

            // VNPay amount = tiền * 100
            if ((long)(payment.Amount * 100) != validation.Amount)
            {
                return Ok(new { RspCode = "04", Message = "Invalid amount" });
            }

            // 🔽 Lấy booking tương ứng
            var booking = await _context.Bookings.FindAsync(payment.BookingID);

            if (validation.ResponseCode == "00" && validation.TransactionStatus == "00")
            {
                payment.Status = "Success";
                payment.PaymentDate = DateTime.Now;

                if (booking != null && booking.Status == "Pending")
                {
                    booking.Status = "Paid";   // 👈 booking đã thanh toán
                }
            }
            else
            {
                payment.Status = "Failed";
                // booking vẫn Pending để user thanh toán lại
            }

            await _context.SaveChangesAsync();

            return Ok(new { RspCode = "00", Message = "Confirm Success" });
        }
    }
}
