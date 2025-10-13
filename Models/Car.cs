namespace SDCRMS.Models
{
    public class Car
    {
        public int CarID { get; set; }
        public string NameCar { get; set; } = string.Empty;
        public string LicensePlate { get; set; } = string.Empty;
        public int ModelYear { get; set; }
        public bool State { get; set; }
        public string Seat { get; set; } = string.Empty;
        public string TypeCar { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public string urlImage { get; set; } = string.Empty;

        public int OwnerCarID { get; set; }
        public OwnerCar? OwnerCar { get; set; }
        public List<Booking> Bookings { get; set; } = new List<Booking>();
        public List<Maintenance> Maintenances { get; set; } = new List<Maintenance>();
    }
}