using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SDCRMS.Dtos.Review;
using SDCRMS.Mappers;
using SDCRMS.Models;
using System.Threading.Tasks;
using System.Linq;

namespace SDCRMS.Controllers
{
    [Route("api/review")]
    [ApiController]
    public class ReviewController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ReviewController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/review
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var reviews = await _context.Reviews.ToListAsync();
            return Ok(reviews);
        }

        // GET: api/review/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetID([FromRoute] int id)
        {
            var review = await _context.Reviews.FindAsync(id);
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
            var reviewModel = reviewDto.ToReviewModel();

            await _context.Reviews.AddAsync(reviewModel);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetID), new { id = reviewModel.ReviewID }, reviewModel);
        }

        // PUT: api/review/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update([FromRoute] int id, [FromBody] UpdateReviewRequestDto updateDto)
        {
            var reviewModel = await _context.Reviews.FirstOrDefaultAsync(x => x.ReviewID == id);
            if (reviewModel == null)
            {
                return NotFound();
            }

            reviewModel.Rating = updateDto.Rating;
            reviewModel.Comment = updateDto.Comment;

            await _context.SaveChangesAsync();
            return NoContent();
        }

        // DELETE: api/review/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete([FromRoute] int id)
        {
            var reviewModel = await _context.Reviews.FirstOrDefaultAsync(x => x.ReviewID == id);
            if (reviewModel == null)
            {
                return NotFound();
            }

            _context.Reviews.Remove(reviewModel);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
