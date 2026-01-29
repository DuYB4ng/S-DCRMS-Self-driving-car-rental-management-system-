using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BookingService.Dtos.Review;
using Controllers;

using System.Threading.Tasks;
using System.Linq;
using BookingService.Interfaces;
using BookingService.Mappers;

namespace Controllers
{
    [Route("api/review")]
    [ApiController]
    public class ReviewController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IReviewRepository _reviewRepo;

        public ReviewController(AppDbContext context, IReviewRepository reviewRepo)
        {
            _context = context;
            _reviewRepo = reviewRepo;
        }

        // GET: api/review
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var reviews = await _reviewRepo.GetAllAsync();
            return Ok(reviews);
        }

        // GET: api/review/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetID([FromRoute] int id)
        {
            var review = await _reviewRepo.GetByIdAsync(id);
            if (review == null)
            {
                return NotFound();
            }

            return Ok(review);
        }

        // POST: api/review
        [HttpPost]
        public async Task<IActionResult> TaoReview([FromBody] CreateReviewRequestDto reviewDto)
        {
            // 1. Lấy Booking tương ứng với review
            var booking = await _context.Bookings
                .Include(b => b.Reviews)
                .FirstOrDefaultAsync(b => b.BookingID == reviewDto.BookingID);

            if (booking == null)
            {
                return BadRequest(new { message = "Booking not found" });
            }

            // 2. Chỉ cho review nếu booking đã check-out xong
            if (!booking.CheckOut)
            {
                return BadRequest(new { message = "Booking must be checked out before reviewing" });
            }

            // 3. Nếu muốn mỗi booking chỉ 1 review:
            if (booking.Reviews.Any())
            {
                return BadRequest(new { message = "This booking has already been reviewed" });
            }

            // 4. Tạo review như cũ
            var reviewModel = reviewDto.ToReviewModel();

            await _reviewRepo.CreateAsync(reviewModel);

            return CreatedAtAction(
                nameof(GetID),
                new { id = reviewModel.ReviewID },
                reviewModel.toReviewDto()
            );
        }

        // PUT: api/review/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update([FromRoute] int id, [FromBody] UpdateReviewRequestDto updateDto)
        {
            var reviewModel = await _reviewRepo.UpdateAsync(id, updateDto);
            if (reviewModel == null)
            {
                return NotFound();
            }

            await _context.SaveChangesAsync();
            return NoContent();
        }

        // DELETE: api/review/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete([FromRoute] int id)
        {
            var reviewModel = await _reviewRepo.DeleteAsync(id);
            if (reviewModel == null)
            {
                return NotFound();
            }

            return NoContent();
        }

        // GET: api/review/car/5
        [HttpGet("car/{carId}")]
        public async Task<IActionResult> GetByCar(int carId)
        {
            var reviews = await _context.Reviews
                .Include(r => r.Booking)
                .Where(r => r.Booking.CarId == carId && r.Booking.CheckOut)
                .Select(r => new
                {
                    r.ReviewID,
                    r.Rating,
                    r.Comment,
                    bookingId = r.BookingID,
                    carId = r.Booking.CarId,
                    startDate = r.Booking.StartDate,
                    endDate = r.Booking.EndDate,
                })
                .ToListAsync();

            return Ok(reviews);
        }

        // GET: api/review/booking/{bookingId}
        [HttpGet("booking/{bookingId}")]
        public async Task<IActionResult> GetByBooking(int bookingId)
        {
            var review = await _context.Reviews
                .Where(r => r.BookingID == bookingId)
                .Select(r => new 
                {
                    r.ReviewID,
                    r.Rating,
                    r.Comment,
                    r.ReviewDate
                })
                .FirstOrDefaultAsync();

            return Ok(review); // returns null (204 or just null json) if not found
        }
    }
}