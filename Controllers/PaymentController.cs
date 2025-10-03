
using Microsoft.AspNetCore.Mvc;
using SDCRMS.Mappers;

using SDCRMS.Dtos.Payment;

namespace SDCRMS.Controllers
{
    [Route("api/payment")]
    [ApiController]
    public class PaymentController:ControllerBase
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
            var paymentModel = payDto.toPaymentDto();
            _context.Payments.Add(paymentModel);
            _context.SaveChanges();
            return CreatedAtAction(nameof(GetID), new { id = paymentModel.PaymentID }, payDto.toPaymentDto());
        }
        //[HttpPut]

        //[HttpDelete]
    }
}
