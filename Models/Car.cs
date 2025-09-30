namespace SDCRMS.Models
{
    public class Car
    {
        public int CarID { get; set; }
        public int OwnerID { get; set; }
        public string NameCar { get; set; }
        public string LicensePlate { get; set; }
        public DateTime ModelYear { get; set; }
        public bool State { get; set; }
        public string Seat { get; set; }
        public string TypeCar { get; set; }
        public decimal Price { get; set; }
        public string urlImage { get; set; }
    }
}