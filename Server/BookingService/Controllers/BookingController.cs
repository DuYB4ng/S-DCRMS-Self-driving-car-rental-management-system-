using Microsoft.AspNetCore.Mvc;
using BookingService.Mappers;
using BookingService.Dtos.Booking;
using Microsoft.EntityFrameworkCore;
using BookingService.Interfaces;
using BookingService.Services;
using Microsoft.AspNetCore.Authorization;
using BookingService.Constants;

namespace BookingService.Controllers
{
    [Route("api/Booking")]
    [ApiController]
    public class BookingController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IBookingRepository _bookingRepo;
        private readonly CustomerClient _customerClient;
        public BookingController(AppDbContext context, IBookingRepository bookingRepo, CustomerClient customerClient)
        {
            _context = context;
            _bookingRepo = bookingRepo;
            _customerClient = customerClient;
        }

        [HttpGet]
        public async Task<IActionResult> Getall()
        {
            await CleanupExpiredPendingBookingsAsync();
            var bookings = await _bookingRepo.getAllAsync();
            var dtoBooking = bookings.Select(s => s.ToBookingDto());
            return Ok(dtoBooking);
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
        [AllowAnonymous]
        public async Task<IActionResult> Create(
            [FromBody] CreateBookingDto bookingDto,
            [FromQuery] string? firebaseUid)  
        {
            int customerId;

            // ===== 1. Xác định customerId theo firebaseUid (DEV MODE) =====
            if (string.IsNullOrEmpty(firebaseUid))
            {
                return BadRequest("firebaseUid is required in dev mode");
            }

            var customer = await _customerClient.GetByFirebaseUidAsync(firebaseUid);
            if (customer == null)
            {
                return BadRequest(new { message = "Customer profile not found" });
            }

            customerId = customer.CustomerId;

            // ===== 2. Validate thời gian =====
            if (bookingDto.EndDate <= bookingDto.StartDate)
            {
                return BadRequest(new { message = "Thời gian trả xe phải sau thời gian nhận xe." });
            }

            // ===== 3. Kiểm tra trùng lịch =====
            var hasOverlapBooking = await _context.Bookings
                .AnyAsync(b =>
                    b.CarId == bookingDto.CarId &&
                    b.Status != BookingStatuses.Cancelled &&
                    b.StartDate < bookingDto.EndDate &&
                    b.EndDate > bookingDto.StartDate);

            if (hasOverlapBooking)
            {
                return Conflict(new
                {
                    message = "Xe này đã có người đặt trong khoảng thời gian bạn chọn. Vui lòng chọn xe hoặc khung giờ khác."
                });
            }

            // ===== 4. Tạo booking =====
            var bookingModel = await _bookingRepo.createAsync(bookingDto, customerId);

            return CreatedAtAction(nameof(GetById),
                new { id = bookingModel.BookingID },
                bookingModel.ToBookingDto());
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
            // Lấy booking
            var booking = await _context.Bookings.FindAsync(id);
            if (booking == null)
                return NotFound(new { message = "Booking not found" });

            // Lấy firebaseUid từ JWT (giống Create)
            int customerId;
            var firebaseUid =
                User.FindFirst("firebaseUid")?.Value ??
                User.FindFirst("user_id")?.Value;

            if (string.IsNullOrEmpty(firebaseUid))
            {
                // DEV MODE: fallback CustomerId = 1
                customerId = 1;
            }
            else
            {
                var customer = await _customerClient.GetByFirebaseUidAsync(firebaseUid);
                if (customer == null)
                    return BadRequest(new { message = "Customer profile not found" });

                customerId = customer.CustomerId;
            }

            // Chỉ chủ booking mới được check-in
            if (booking.CustomerId != customerId)
                return Forbid();

            // Chỉ cho check-in khi đã thanh toán
            if (!string.Equals(booking.Status, BookingStatuses.Paid, StringComparison.OrdinalIgnoreCase))
                return BadRequest(new { message = $"Booking must be '{BookingStatuses.Paid}' before check-in" });

            if (booking.CheckIn)
                return BadRequest(new { message = "Booking already checked in" });

            // Cập nhật trạng thái check-in
            booking.CheckIn = true;
            booking.Status = BookingStatuses.InProgress;

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

            // Lấy current customer
            int customerId;
            var firebaseUid =
                User.FindFirst("firebaseUid")?.Value ??
                User.FindFirst("user_id")?.Value;

            if (string.IsNullOrEmpty(firebaseUid))
            {
                customerId = 1; // DEV MODE
            }
            else
            {
                var customer = await _customerClient.GetByFirebaseUidAsync(firebaseUid);
                if (customer == null)
                    return BadRequest(new { message = "Customer profile not found" });

                customerId = customer.CustomerId;
            }

            // Chỉ chủ booking mới được check-out
            if (booking.CustomerId != customerId)
                return Forbid();

            // Phải check-in rồi mới được check-out
            if (!booking.CheckIn)
                return BadRequest(new { message = "Booking must be checked in before check-out" });

            if (booking.CheckOut)
                return BadRequest(new { message = "Booking already checked out" });

            booking.CheckOut = true;
            booking.Status = BookingStatuses.Completed;

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

        private async Task CleanupExpiredPendingBookingsAsync()
        {
            var now = DateTime.UtcNow;
            var timeoutMinutes = 15;

            var expired = await _context.Bookings
                .Where(b => b.Status == "Pending" &&
                            b.CreatedAt < now.AddMinutes(-timeoutMinutes))
                .ToListAsync();

            if (expired.Any())
            {
                _context.Bookings.RemoveRange(expired);
                await _context.SaveChangesAsync();
            }
        }

        // GET: api/Booking/my
        [HttpGet("my")]
        public async Task<IActionResult> GetMyBookings([FromQuery] string? firebaseUid)
        {
            if (string.IsNullOrEmpty(firebaseUid))
            {
                return BadRequest("firebaseUid is required in dev mode");
            }

            // Lấy customer theo firebaseUid
            var customer = await _customerClient.GetByFirebaseUidAsync(firebaseUid);
            if (customer == null)
            {
                return BadRequest(new { message = "Customer profile not found" });
            }

            var customerId = customer.CustomerId;

            await CleanupExpiredPendingBookingsAsync();

            var bookings = await _context.Bookings
                .Where(b => b.CustomerId == customerId)
                .OrderByDescending(b => b.CreatedAt)
                .ToListAsync();

            var dtoBooking = bookings.Select(b => b.ToBookingDto());
            return Ok(dtoBooking);
        }

    }
}