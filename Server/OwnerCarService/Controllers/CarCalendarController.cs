using Microsoft.AspNetCore.Mvc;
using OwnerCarService.Services;
using System.ComponentModel.DataAnnotations;

namespace OwnerCarService.Controllers
{
    [ApiController]
    [Route("api/calendar")]
    public class CarCalendarController : ControllerBase
    {
        private readonly ICarCalendarService _service;

        public CarCalendarController(ICarCalendarService service)
        {
            _service = service;
        }

        [HttpGet("{carId}")]
        public async Task<IActionResult> GetCalendar(int carId)
        {
            var result = await _service.GetCalendarAsync(carId);
            return Ok(result);
        }

        [HttpPost("block")]
        public async Task<IActionResult> BlockDate([FromBody] CalendarRequest request)
        {
            if (request == null) return BadRequest("Invalid request");
            
            var result = await _service.BlockDateAsync(request.CarId, request.Date);
            return Ok(result);
        }

        [HttpPost("unblock")]
        public async Task<IActionResult> UnblockDate([FromBody] CalendarRequest request)
        {
            if (request == null) return BadRequest("Invalid request");

            var result = await _service.UnblockDateAsync(request.CarId, request.Date);
            if (!result) return NotFound("Date not found or already unblocked");
            
            return Ok(new { message = "Unblocked successfully" });
        }
    }

    public class CalendarRequest
    {
        [Required]
        public int CarId { get; set; }
        
        [Required]
        public DateTime Date { get; set; }
    }
}
