namespace OwnerCarService.Models
{
    public class Car
    {
        public int CarID { get; set; }

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
        public DateTime? UpdatedAt { get; set; }
        // Pricing & status
        public decimal PricePerDay { get; set; }
        public decimal Deposit { get; set; }
        public bool IsActive { get; set; } = true;
        public string Status { get; set; } = "Active"; // Active, UnderMaintenance, Disabled
        public string Location { get; set; } = string.Empty;

        // Ownership & registration
        public string OwnershipDocumentNumber { get; set; } = string.Empty;
        public string OwnershipType { get; set; } = "Personal"; // Personal, Company, Lease
        public DateTime RegistrationDate { get; set; }
        public string RegistrationPlace { get; set; } = string.Empty;
        public DateTime InsuranceExpiryDate { get; set; }
        public DateTime InspectionExpiryDate { get; set; }

        // Display info
        public string Description { get; set; } = string.Empty;
        public List<String> imageUrls { get; set; } = new();

        // Relations
        public int OwnerCarID { get; set; }
        public OwnerCar? OwnerCar { get; set; }
        public List<Maintenance> Maintenances { get; set; } = new();
    }
}
