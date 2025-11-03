using SDCRMS.Models;
using SDCRMS.Dtos.Review;

namespace SDCRMS.Mappers
{
   public static class ReviewMapper
    {
      public static Review toReviewDto(this Review reviewModel)
        {
            return new Review
            {
                ReviewID = reviewModel.ReviewID,
                Rating = reviewModel.Rating,
                Comment = reviewModel.Comment,
                ReviewDate = reviewModel.ReviewDate
            };
        }
      public static Review ToReviewModel(this CreateReviewRequestDto reviewDto)
        {
            return new Review
            {
                ReviewID = reviewDto.ReviewID,
                Rating = reviewDto.Rating,
                Comment = reviewDto.Comment,
                ReviewDate = reviewDto.ReviewDate
            };
        }

    }
}
