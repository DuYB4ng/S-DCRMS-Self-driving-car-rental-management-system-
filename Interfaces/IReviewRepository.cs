using SDCRMS.Dtos.Review;

using SDCRMS.Models;

namespace SDCRMS.Interfaces
{
    public interface IReviewRepository
    {
        Task<List<Review>> GetAllAsync();
        Task<Review?> GetByIdAsync(int id);
        Task<Review?> CreateAsync(Review reviewModel);
        Task<Review?> UpdateAsync(int id, UpdateReviewRequestDto reviewDto);

        Task<Review?> DeleteAsync(int id);
    }
}
