using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

using paymentServices.Models;
using System.Threading.Tasks;
using System.Linq;
using paymentServices.Interfaces;
using paymentServices.Dtos.Payment;
using paymentService.Mappers;

namespace paymentServices.Controllers
{
    [Route("api/payment")]
    [ApiController]
    public class PaymentController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IPaymentRepository _paymentRepo;

        public PaymentController(AppDbContext context, IPaymentRepository paymentRepo)
        {
            _context = context;
            _paymentRepo = paymentRepo;
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

        // POST: api/payment
        [HttpPost]
        public async Task<IActionResult> TaoPayment([FromBody] CreatePaymentRequestDto payDto)
        {
            var paymentModel = payDto.ToPaymentFromCreateDto();

            await _paymentRepo.CreateAsync(paymentModel);

            return CreatedAtAction(nameof(GetID), new { id = paymentModel.PaymentID }, paymentModel.toPaymentDto());
        }

        // PUT: api/payment/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update([FromRoute] int id, [FromBody] UpdatePaymentRequestDto updateDto)
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
    }
}
