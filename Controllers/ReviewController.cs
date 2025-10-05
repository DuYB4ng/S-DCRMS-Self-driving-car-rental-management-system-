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
                    var ReviewModel = reviewDto.
                }

            }
        }
}
