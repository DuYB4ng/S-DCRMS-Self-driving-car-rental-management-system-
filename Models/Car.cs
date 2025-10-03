namespace SDCRMS.Models
{
    public class Car
    {
        public int CarID { get; set; }
        public int OwnerID { get; set; }
        public string NameCar { get; set; } = string.Empty;
        public string LicensePlate { get; set; } = string.Empty;
        public DateTime ModelYear { get; set; }
        public bool State { get; set; }
        public string Seat { get; set; } = string.Empty;
        public string TypeCar { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public string UrlImage { get; set; } = string.Empty;
    }
}
