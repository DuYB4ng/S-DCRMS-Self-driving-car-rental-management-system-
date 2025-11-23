using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BookingService.Models;
using System.Threading.Tasks;
using System.Linq;
using BookingService.Interfaces;
using BookingService.Dtos.Payment;
using BookingService.Mappers;
using BookingService.Services;
using BookingService.VnPay;

namespace BookingService.Controllers
{
    [Route("api/payment")]
    [ApiController]
    public class PaymentController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IPaymentRepository _paymentRepo;
        private readonly IVnPayService _vnPayService;

        public PaymentController(
            AppDbContext context,
            IPaymentRepository paymentRepo,
            IVnPayService vnPayService)
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

        // POST: api/payment/create-vnpay
        [HttpPost("create-vnpay")]
        public async Task<IActionResult> CreateVnPayPayment([FromBody] CreateVnPayPaymentRequestDto dto)
        {
            // 1. kiểm tra booking
            var booking = await _context.Bookings.FirstOrDefaultAsync(b => b.BookingID == dto.BookingID);
            if (booking == null)
            {
                return NotFound(new { message = "Booking not found" });
            }

            // 2. tạo payment pending trong DB
            var payment = new Payment
            {
                PaymentDate = DateTime.UtcNow,
                Amount = dto.Amount,       // decimal
                Method = "VNPAY",
                Status = "Pending",
                BookingID = dto.BookingID
            };
            await _paymentRepo.CreateAsync(payment);

            // 3. map sang PaymentInformationModel (dùng double, nên cast)
            var info = new PaymentInformationModel
            {
                PaymentId       = payment.PaymentID,   
                OrderType        = "other",
                Amount           = (double)dto.Amount,
                OrderDescription = $"Thanh toan booking {dto.BookingID}, payment {payment.PaymentID}",
                Name             = "Khach hang"
            };

            // 4. tạo URL VNPAY
            var paymentUrl = _vnPayService.CreatePaymentUrl(info, HttpContext);

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
            // Dùng service mới để validate chữ ký & đọc dữ liệu
            var response = _vnPayService.PaymentExecute(Request.Query);

            if (!response.Success)
            {
                // Sai chữ ký
                return Ok(new { RspCode = "97", Message = "Invalid signature" });
            }

            // Lấy PaymentID từ vnp_TxnRef (response.OrderId)
            if (!int.TryParse(response.OrderId, out var paymentId))
            {
                return Ok(new { RspCode = "01", Message = "Invalid order id" });
            }

            var payment = await _paymentRepo.GetByIdAsync(paymentId);
            if (payment == null)
            {
                return Ok(new { RspCode = "01", Message = "Order not found" });
            }

            // Kiểm tra số tiền (nếu muốn chặt chẽ)
            if (Request.Query.TryGetValue("vnp_Amount", out var amountStr)
                && long.TryParse(amountStr, out var amountFromVnp))
            {
                var expected = (long)(payment.Amount * 100);
                if (expected != amountFromVnp)
                {
                    return Ok(new { RspCode = "04", Message = "Invalid amount" });
                }
            }

            // Lấy booking tương ứng
            var booking = await _context.Bookings.FindAsync(payment.BookingID);

            // response.VnPayResponseCode == "00" là thanh toán thành công
            if (response.VnPayResponseCode == "00")
            {
                payment.Status = "Completed";
                payment.PaymentDate = DateTime.Now;

                if (booking != null && booking.Status == "Pending")
                {
                    booking.Status = "Paid";
                }
            }
            else
            {
                payment.Status = "Failed";
            }

            await _context.SaveChangesAsync();

            // Chuẩn IPN của VNPay: xử lý ok thì trả RspCode = "00"
            return Ok(new { RspCode = "00", Message = "Confirm Success" });
        }


        // GET: api/payment/vnpay-return
        [HttpGet("vnpay-return")]
        public IActionResult VnPayReturn()
        {
            var response = _vnPayService.PaymentExecute(Request.Query);
            return Ok(response);
        }
    }
}
