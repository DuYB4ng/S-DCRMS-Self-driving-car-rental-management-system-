using Microsoft.AspNetCore.Mvc;
using SDCRMS.Mappers;
using SDCRMS.Dtos.Booking;
using Microsoft.EntityFrameworkCore;
using SDCRMS.Models;
using SDCRMS.Repositories;
namespace SDCRMS.Controllers
{
    [Route("api/Booking")]
    [ApiController]
    public class BookingController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IBookingRepository _bookingRepo;
        public BookingController(AppDbContext context, IBookingRepository bookingRepo)
        {
            _context = context;
            _bookingRepo = bookingRepo;
        }

        [HttpGet]
        public async Task<IActionResult> Getall() 
        {
            var bookings = await _bookingRepo.getAllAsync();
            var dtoBooking = bookings.Select(s=>s.ToBookingDto());
            return Ok(bookings);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById([FromRoute]int id) 
        {
            var booking = await _bookingRepo.getByIdAsync(id);
            if (booking == null)
            {
                return NotFound();
            }
            return Ok(booking.ToBookingDto());
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody]CreateBookingDto bookingDto)
        {
            var bookingModel = await _bookingRepo.createAsync(bookingDto);
            return CreatedAtAction(nameof(GetById), new { id = bookingModel.BookingID }, bookingModel);
        }

        [HttpPut]
        [Route("{id}")]
        public async Task<IActionResult> Update([FromRoute]int id, [FromBody] UpdateBookingDto bookingDto)
        {
            var existingBooking = await _bookingRepo.updateAsync(id, bookingDto);
            if (existingBooking is null) return NotFound();
            return Ok(existingBooking.ToBookingDto());
        }

        [HttpDelete]
        [Route("{id}")]
        public async Task<IActionResult> Delete([FromRoute]int id)
        {
            var existingBooking = await _bookingRepo.deleteAsync(id);
            if (!existingBooking)
            {
                return NotFound();
            }
            return NoContent();
        }

    }
}
