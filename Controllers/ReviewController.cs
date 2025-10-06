using Microsoft.AspNetCore.Mvc;
using SDCRMS.Dtos.Review;

namespace SDCRMS.Controllers
{
    public class ReviewController
    {
        public class ReviewMapper
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
                [HttpGet]
                public IActionResult getAll()
                {
                    var ReviewModel = _context.Reviews.ToList();
                    return Ok(ReviewModel);
                }
                [HttpGet("id")]
                public IActionResult GetID([FromRoute] int id)
                {
                    var ReviewModel = _context.Reviews.Find(id);
                    if (ReviewModel == null)
                    {
                        return NotFound();
                    }
                    return Ok(ReviewModel);
                }
                [HttpPost]
                public IActionResult taoReview([FromBody] CreateReviewRequestDto reviewDto)
                {
                    var ReviewModel = reviewDto.ToReviewModel();
                    _context.Reviews.Add(ReviewModel);
                    _context.SaveChanges();
                    return CreatedAtAction(nameof(GetID), new { id = ReviewModel.ReviewID }, reviewDto.ToReviewModel());
                }
                [HttpPut]
                [Route("{id}")]
                public IActionResult Update([FromRoute] int id, [FromBody] UpdateReviewRequestDto updateDto)
                {
                    var ReviewModel = _context.Reviews.FirstOrDefault(x => x.ReviewID == id);
                    if (ReviewModel == null)
                    {
                        return NotFound();
                    }
                    ReviewModel.ReviewID = updateDto.ReviewID;
                    ReviewModel.Rating = updateDto.Rating;
                    ReviewModel.Comment = updateDto.Comment;
                    ReviewModel.ReviewDate = updateDto.ReviewDate;
                    ReviewModel.CustomerID = updateDto.CustomerID;
                    ReviewModel.Customer = updateDto.Customer;
                    _context.SaveChanges();
                    return NoContent();
                }
                [HttpDelete]
                [Route("{id}")]
                public IActionResult Delete([FromRoute] int id)
                {
                    var ReviewModel = _context.Reviews.FirstOrDefault(x => x.ReviewID == id);
                    if (ReviewModel == null)
                    {
                        return NotFound();
                    }
                    _context.Reviews.Remove(ReviewModel);
                    _context.SaveChanges();
                    return NoContent();
                }

            }
        }
}
