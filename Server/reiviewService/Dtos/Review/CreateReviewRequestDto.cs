namespace reiviewService.Dtos.Review
{
    public class CreateReviewRequestDto
    {
        public int ReviewID { get; set; }
        public int Rating { get; set; }
        public string Comment { get; set; }
        public DateTime ReviewDate { get; set; } = DateTime.Now;
    }
    
}
