namespace OwnerCarService.Dtos
{
    public class CarLocationDto
    {
        public int CarID { get; set; }
        public double Lat { get; set; }
        public double Lng { get; set; }
        public double Speed { get; set; }
        public DateTime Timestamp { get; set; } = DateTime.UtcNow;
    }
}
