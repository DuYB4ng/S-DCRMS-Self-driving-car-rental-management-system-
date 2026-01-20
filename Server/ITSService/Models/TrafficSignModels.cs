namespace ITSService.Models
{
    public class TrafficSignRecognitionRequest
    {
        public string? ImageUrl { get; set; }
        public string? ImageBase64 { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public DateTime Timestamp { get; set; }
    }

    public class TrafficSignRecognitionResponse
    {
        public string SignType { get; set; } = string.Empty; // e.g., "Stop", "SpeedLimit50"
        public double Confidence { get; set; }
        public string Message { get; set; } = string.Empty;
    }
}
