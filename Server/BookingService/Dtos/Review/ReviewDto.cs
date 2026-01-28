namespace BookingService.Dtos.Review
{
    public class ReviewDto
    {
        public int ReviewID { get; set; }
        public int Rating { get; set; }
        public string Comment { get; set; } = string.Empty;
        public DateTime ReviewDate { get; set; }
    }
}
