namespace SDCRMS.Dtos.Car
{
    public class CreateCarDTO
    {
        // Basic info
        public string NameCar { get; set; } = string.Empty;
        public string LicensePlate { get; set; } = string.Empty;
        public int ModelYear { get; set; }
        public int Seat { get; set; }
        public string TypeCar { get; set; } = string.Empty;
        public string Transmission { get; set; } = "Automatic";
        public string FuelType { get; set; } = "Gasoline";
        public double FuelConsumption { get; set; }
        public string Color { get; set; } = string.Empty;

        // Pricing
        public decimal PricePerDay { get; set; }
        public decimal Deposit { get; set; }

        // Location & availability
        public string Location { get; set; } = string.Empty;
        public bool IsActive { get; set; } = true;

        // Ownership & registration
        public string OwnershipType { get; set; } = "Personal";
        public DateTime RegistrationDate { get; set; }
        public string RegistrationPlace { get; set; } = string.Empty;
        public DateTime InsuranceExpiryDate { get; set; }
        public DateTime InspectionExpiryDate { get; set; }

        // Display
        public string Description { get; set; } = string.Empty;
        public List<string> ImageUrls { get; set; } = new();

        // Relation
        public int OwnerCarID { get; set; }
    }
}
