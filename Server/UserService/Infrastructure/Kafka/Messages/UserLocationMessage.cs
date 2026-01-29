namespace Infrastructure.Kafka.Messages;

public class UserLocationMessage
{
    public string FirebaseUid { get; set; } = default!;
    public double Latitude { get; set; }
    public double Longitude { get; set; }
    public DateTime Timestamp { get; set; }
}
