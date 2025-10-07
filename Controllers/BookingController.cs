using Microsoft.AspNetCore.Mvc;
using SDCRMS.Mappers;
using SDCRMS.Dtos.Booking;
using Microsoft.EntityFrameworkCore;

namespace SDCRMS.Controllers
{
    [Route("api/Booking")]
    [ApiController]
    public class BookingController : ControllerBase
    {
        private readonly AppDbContext _context;
        public BookingController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> Getall() 
        {
            var bookings = await _context.Bookings.ToListAsync();
            var dtoBooking = bookings.Select(s=>s.ToBookingDto());
            return Ok(bookings);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById([FromRoute]int id) 
        {
            var booking = await _context.Bookings.FindAsync(id);
            if (booking == null)
            {
                return NotFound();
            }
            return Ok(booking.ToBookingDto());
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody]CreateBookingDto bookingDto)
        {
            var bookingModel = bookingDto.ToCreateBookingDto();
            await _context.Bookings.AddAsync(bookingModel);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetById), new { id = bookingModel.BookingID }, bookingModel.ToBookingDto());
        }

        [HttpPut]
        [Route("{id}")]
        public async Task<IActionResult> Update([FromRoute]int id, [FromBody] UpdateBookingDto bookingDto)
        {
            var existingBooking = await _context.Bookings.FindAsync(id); 
            if (existingBooking == null)
            {
                return NotFound();
            }
            existingBooking.StartDate = bookingDto.StartDate;
            existingBooking.EndDate = bookingDto.EndDate;
            existingBooking.CheckIn = bookingDto.CheckIn;
            existingBooking.CheckOut = bookingDto.CheckOut;
            await _context.SaveChangesAsync();
            return Ok(existingBooking.ToBookingDto());
        }

        [HttpDelete]
        [Route("{id}")]
        public async Task<IActionResult> Delete([FromRoute]int id)
        {
            var existingBooking = await _context.Bookings.FindAsync(id);
            if (existingBooking == null)
            {
                return NotFound();
            }
            _context.Bookings.Remove(existingBooking);
            await _context.SaveChangesAsync();
            return NoContent();
        }

    }
}
