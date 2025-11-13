using Microsoft.EntityFrameworkCore;
using BookingService.Dtos.Review;
using BookingService.Interfaces;
using BookingService.Models;

namespace BookingService.Repositories
{
    public class ReviewRepository : IReviewRepository
    {
        private readonly AppDbContext _context;
        public ReviewRepository(AppDbContext context)
        {
            _context = context;
        }
        public async Task<Review?> CreateAsync(Review reviewModel)
        {
            await _context.Reviews.AddAsync(reviewModel);
            await _context.SaveChangesAsync();
            return reviewModel;
        }

        public async Task<Review?> DeleteAsync(int id)
        {
            var reviewModel = await _context.Reviews.FirstOrDefaultAsync( x=> x.ReviewID == id);
            if (reviewModel == null)
            {
                return null;
            }
            _context.Reviews.Remove(reviewModel);
            await _context.SaveChangesAsync();
            return reviewModel;
        }

        public async Task<List<Review>> GetAllAsync()
        {
          return await _context.Reviews.ToListAsync();
        }

        public async Task<Review?> GetByIdAsync(int id)
        {
           return await _context.Reviews.FindAsync(id);
        }

        public async Task<Review?> UpdateAsync(int id, UpdateReviewRequestDto reviewDto)
        {
           var existingReview = await _context.Reviews.FirstOrDefaultAsync(x => x.ReviewID == id);
            if (existingReview == null) { 
            return null;
            }

            existingReview.Rating = reviewDto.Rating;
            existingReview.Comment = reviewDto.Comment;
            

            await _context.SaveChangesAsync();
            return existingReview;
        }

        
    }
}