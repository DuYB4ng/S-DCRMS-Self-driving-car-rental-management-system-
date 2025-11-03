using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SDCRMS.Mappers;
using SDCRMS.Dtos.Payment;
using SDCRMS.Models;
using System.Threading.Tasks;
using System.Linq;

namespace SDCRMS.Controllers
{
    [Route("api/payment")]
    [ApiController]
    public class PaymentController : ControllerBase
    {
        private readonly AppDbContext _context;

        public PaymentController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/payment
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var payments = await _context.Payments.ToListAsync();
            return Ok(payments);
        }

        // GET: api/payment/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetID([FromRoute] int id)
        {
            var payment = await _context.Payments.FindAsync(id);
            if (payment == null)
            {
                return NotFound();
            }

            return Ok(payment);
        }

        // POST: api/payment
        [HttpPost]
        public async Task<IActionResult> TaoPayment([FromBody] CreatePaymentRequestDto payDto)
        {
            var paymentModel = payDto.ToPaymentFromCreateDto();

            await _context.Payments.AddAsync(paymentModel);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetID), new { id = paymentModel.PaymentID }, paymentModel.toPaymentDto());
        }

        // PUT: api/payment/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update([FromRoute] int id, [FromBody] UpdatePaymentRequestDto updateDto)
        {
            var paymentModel = await _context.Payments.FirstOrDefaultAsync(x => x.PaymentID == id);
            if (paymentModel == null)
            {
                return NotFound();
            }

            paymentModel.PaymentDate = updateDto.PaymentDate;
            paymentModel.Amount = updateDto.Amount;
            paymentModel.Method = updateDto.Method;
            paymentModel.Status = updateDto.Status;
            paymentModel.BookingID = updateDto.BookingID;
            paymentModel.Booking = updateDto.Booking;

            await _context.SaveChangesAsync();

            return Ok(paymentModel.toPaymentDto());
        }

        // DELETE: api/payment/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete([FromRoute] int id)
        {
            var paymentModel = await _context.Payments.FirstOrDefaultAsync(x => x.PaymentID == id);
            if (paymentModel == null)
            {
                return NotFound();
            }

            _context.Payments.Remove(paymentModel);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
