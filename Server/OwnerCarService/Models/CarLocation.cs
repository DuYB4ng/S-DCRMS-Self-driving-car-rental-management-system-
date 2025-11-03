namespace OwnerCarService.Models
{
    public class CarLocation
    {
        public int Id { get; set; }
        public int CarID { get; set; }
        public Car? Car { get; set; }

        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public double Speed { get; set; } // km/h
        public DateTime Timestamp { get; set; } = DateTime.UtcNow;
    }
}
