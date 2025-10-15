
using Microsoft.AspNetCore.Mvc;
using SDCRMS.Mappers;

using SDCRMS.Dtos.Payment;

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
        [HttpGet]
        public IActionResult GetAll()
        {
            var payments = _context.Payments.ToList();
            return Ok(payments);
        }
        [HttpGet("{id}")]
        public IActionResult GetID([FromRoute] int id)
        {
            var payments = _context.Payments.Find(id);
            if (payments == null)
            {
                return NotFound();
            }
            return Ok(payments);
        }

        [HttpPost]
        public IActionResult taoPayment([FromBody] CreatePaymentRequestDto payDto)
        {
            var paymentModel = payDto.ToPaymentFromCreateDto();
            _context.Payments.Add(paymentModel);
            _context.SaveChanges();
            return CreatedAtAction(nameof(GetID), new { id = paymentModel.PaymentID }, payDto.ToPaymentFromCreateDto());
        }
        [HttpPut]
        [Route("{id}")]
        public IActionResult Update([FromRoute] int id, [FromBody] UpdatePaymentRequestDto updateDto)
        {
            var PaymentModel = _context.Payments.FirstOrDefault(x => x.PaymentID == id);
            if (PaymentModel == null)
            {
                return NotFound();
            }

            PaymentModel.PaymentID = updateDto.PaymentID;
            PaymentModel.PaymentDate = updateDto.PaymentDate;
            PaymentModel.Amount = updateDto.Amount;
            PaymentModel.Method = updateDto.Method;
            PaymentModel.Status = updateDto.Status;
            PaymentModel.BookingID = updateDto.BookingID;
            PaymentModel.Booking = updateDto.Booking;
            _context.SaveChanges();
            return Ok(PaymentModel.toPaymentDto());

        }

        [HttpDelete]
        [Route("{id}")]
        public IActionResult Delete([FromRoute] int id)
        {
            var paymentModel = _context.Payments.FirstOrDefault(x => x.PaymentID == id);
            if (paymentModel != null)
            {
                return NotFound();
            }
            _context.Payments.Remove(paymentModel);
            _context.SaveChanges();
            return NoContent();
        }
    }
}