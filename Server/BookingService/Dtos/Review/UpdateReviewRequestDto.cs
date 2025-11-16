namespace BookingService.Dtos.Review
{
    public class UpdateReviewRequestDto
    {
        public int Rating { get; set; }
        public string Comment { get; set; }
        public int BookingID { get; set; }

    }
}