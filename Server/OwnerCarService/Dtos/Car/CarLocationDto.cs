using System.Text.Json.Serialization;

namespace OwnerCarService.Dtos
{
    public class CarLocationDto
    {
        [JsonPropertyName("carID")]
        public int CarID { get; set; }

        [JsonPropertyName("latitude")]
        public double Latitude { get; set; }

        [JsonPropertyName("longitude")]
        public double Longitude { get; set; }

        [JsonPropertyName("speed")]
        public double Speed { get; set; }

        public DateTime Timestamp { get; set; } = DateTime.UtcNow;
    }
}
