namespace SDCRMS.Dtos.Car
{
    public class CarDTO
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
    }
}