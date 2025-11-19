using BookingService.Models;
using BookingService.Dtos.Review;

namespace BookingService.Mappers
{
   public static class ReviewMapper
    {
      public static Review toReviewDto(this Review reviewModel)
        {
            return new Review
            {
                Rating = reviewModel.Rating,
                Comment = reviewModel.Comment,
                ReviewDate = reviewModel.ReviewDate,
                BookingID = reviewModel.BookingID
            };
        }
      public static Review ToReviewModel(this CreateReviewRequestDto reviewDto)
        {
            return new Review
            {
                Rating = reviewDto.Rating,
                Comment = reviewDto.Comment,
                ReviewDate = reviewDto.ReviewDate,
                BookingID = reviewDto.BookingID
            };
        }

    }
}