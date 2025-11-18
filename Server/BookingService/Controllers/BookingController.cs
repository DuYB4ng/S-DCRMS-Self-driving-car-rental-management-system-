using Microsoft.AspNetCore.Mvc;
using BookingService.Mappers;
using BookingService.Dtos.Booking;
using Microsoft.EntityFrameworkCore;
using BookingService.Interfaces;

namespace BookingService.Controllers
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
            var dtoBooking = bookings.Select(s => s.ToBookingDto());
            return Ok(bookings);
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
        public async Task<IActionResult> Create([FromBody] CreateBookingDto bookingDto)
        {
            var bookingModel = await _bookingRepo.createAsync(bookingDto);
            return CreatedAtAction(nameof(GetById), new { id = bookingModel.BookingID }, bookingModel);
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
        public async Task<IActionResult> CheckIn(int id)
        {
            var booking = await _context.Bookings.FindAsync(id);
            if (booking == null)
                return NotFound(new { message = "Booking not found" });

            // chỉ cho check-in khi đã thanh toán
            if (booking.Status != "Paid")
                return BadRequest(new { message = "Booking must be Paid before check-in" });

            if (booking.CheckIn)
                return BadRequest(new { message = "Booking already checked in" });

            booking.CheckIn = true;
            booking.Status = "InProgress";

            await _context.SaveChangesAsync();
            return Ok(booking.ToBookingDto());
        }

        // POST: api/booking/{id}/check-out
        [HttpPost("{id}/check-out")]
        public async Task<IActionResult> CheckOut(int id)
        {
            var booking = await _context.Bookings.FindAsync(id);
            if (booking == null)
                return NotFound(new { message = "Booking not found" });

            if (!booking.CheckIn)
                return BadRequest(new { message = "Booking must be checked in before check-out" });

            if (booking.CheckOut)
                return BadRequest(new { message = "Booking already checked out" });

            booking.CheckOut = true;
            booking.Status = "Completed";

            await _context.SaveChangesAsync();
            return Ok(booking.ToBookingDto());
        }

        // POST: api/booking/{id}/cancel
        [HttpPost("{id}/cancel")]
        public async Task<IActionResult> Cancel(int id)
        {
            var booking = await _context.Bookings.FindAsync(id);
            if (booking == null)
                return NotFound(new { message = "Booking not found" });

            if (booking.Status == "Completed" || booking.Status == "Cancelled")
                return BadRequest(new { message = "Booking already completed or cancelled" });

            // tuỳ rule của bạn: chỉ cho cancel khi chưa check-in
            if (booking.CheckIn)
                return BadRequest(new { message = "Cannot cancel after check-in" });

            booking.Status = "Cancelled";

            await _context.SaveChangesAsync();
            return Ok(booking.ToBookingDto());
        }

    }
}