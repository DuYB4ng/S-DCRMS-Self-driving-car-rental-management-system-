namespace BookingService.Dtos.Review
{
    public class UpdateReviewRequestDto
    {
        public int ReviewID { get; set; }
        public int Rating { get; set; }
        public string Comment { get; set; }

    }
}