namespace SDCRMS.Models
{
    public class Car
    {
        public int CarID { get; set; }
        public string NameCar { get; set; }
        public string LicensePlate { get; set; }
        public DateTime ModelYear { get; set; }
        public bool State { get; set; }
        public string Seat { get; set; }
        public string TypeCar { get; set; }
        public decimal Price { get; set; }
        public string urlImage { get; set; } = string.Empty;
        public List<Booking> Bookings { get; set; } = new List<Booking>();
        public List<Maintenance> Maintenances { get; set; } = new List<Maintenance>();
    }
}