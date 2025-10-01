namespace SDCRMS.Models
{
    public class Car
    {
        public int CarID { get; set; }
        public int OwnerID { get; set; }
        public required string NameCar { get; set; }
        public required string LicensePlate { get; set; }
        public DateTime ModelYear { get; set; }
        public bool State { get; set; }
        public required string Seat { get; set; }
        public required string TypeCar { get; set; }
        public decimal Price { get; set; }
        public required string urlImage { get; set; }
    }
}
