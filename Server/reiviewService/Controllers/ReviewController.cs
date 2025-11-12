using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using reiviewService.Dtos.Review;
using Controllers;

using System.Threading.Tasks;
using System.Linq;
using reiviewService.Interfaces;
using reiviewService.Mappers;

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
            var reviewModel = reviewDto.ToReviewModel();

            await _reviewRepo.CreateAsync(reviewModel);

            return CreatedAtAction(nameof(GetID), new { id = reviewModel.ReviewID }, reviewModel.toReviewDto());
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
    }
}
