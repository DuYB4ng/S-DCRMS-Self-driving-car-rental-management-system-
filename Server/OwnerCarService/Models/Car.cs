namespace SDCRMS.Models
{
    public class Car
    {
        public int CarID { get; set; }
        public string NameCar { get; set; } = string.Empty;
        public string LicensePlate { get; set; } = string.Empty;
        public int ModelYear { get; set; }
        public bool State { get; set; }
        public int Seat { get; set; }
        public string TypeCar { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public string urlImage { get; set; } = string.Empty;

        public int OwnerCarID { get; set; }
        public OwnerCar? OwnerCar { get; set; }
        public List<Maintenance> Maintenances { get; set; } = new List<Maintenance>();
    }
}