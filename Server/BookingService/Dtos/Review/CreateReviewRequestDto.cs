namespace BookingService.Dtos.Review
{
    public class CreateReviewRequestDto
    {
        public int Rating { get; set; }
        public string Comment { get; set; }
        public DateTime ReviewDate { get; set; } = DateTime.Now;
        public int BookingID { get; set; }
    }
    
}