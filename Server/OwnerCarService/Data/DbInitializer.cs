using OwnerCarService.Models;

namespace OwnerCarService.Data
{
    public static class DbInitializer
    {
        public static void Initialize(AppDbContext context)
        {
            // Update "CityA/B/C" to real Vietnamese cities for better demo experience
            bool hasChanges = false;

            if (!context.Cars.Any())
            {
                // Console.WriteLine("🌱 Seeding initial cars data...");
                return; // Disable default seeding
                
                /*
                
                // Create a mock OwnerCar
                var testOwner = new OwnerCar
                {
                    FirebaseUid = "test-uid-placeholder", // User will claim this or just for display
                    DrivingLicence = "123456789",
                    LicenceIssueDate = DateTime.Now.AddYears(-5),
                    LicenceExpiryDate = DateTime.Now.AddYears(5),
                    IsActive = true
                };
                context.OwnerCars.Add(testOwner); 
                // Don't SaveChanges yet if we want to rely on navigation fixup, or save to get ID. 
                // EF Core handles navigation properties automatically usually.
                
                var cars = new List<Car>
                {
                    new Car
                    {
                        OwnerCar = testOwner,
                        NameCar = "VinFast VF8 Plus",
                        LicensePlate = "30A-123.45",
                        TypeCar = "SUV",
                        Seat = 5,
                        Transmission = "Automatic",
                        FuelType = "Electric",
                        FuelConsumption = 0,
                        PricePerDay = 1500000,
                        Location = "Hồ Chí Minh",
                        Description = "Xe điện thông minh, rộng rãi, công nghệ hiện đại.",
                        imageUrls = new List<string> { "https://vinfastauto.com/themes/porto/img/vf8/vf8-360.png" },
                        Status = "Available",
                        ModelYear = 2023,
                        Color = "Blue",
                        Deposit = 5000000
                    },
                    new Car
                    {
                        OwnerCar = testOwner,
                        NameCar = "Toyota Camry 2.5Q",
                        LicensePlate = "51G-999.99",
                        TypeCar = "Sedan",
                        Seat = 5,
                        Transmission = "Automatic",
                        FuelType = "Gasoline",
                        FuelConsumption = 8.5,
                        PricePerDay = 1200000,
                        Location = "Hồ Chí Minh",
                        Description = "Sang trọng, đẳng cấp doanh nhân.",
                        imageUrls = new List<string> { "https://toyota-longbien.vn/uploads/images/san-pham/camry/camry-2.5q/camry-2-5q-2022-mau-den.png" },
                        Status = "Available",
                        ModelYear = 2022,
                        Color = "Black",
                        Deposit = 3000000
                    },
                     new Car
                    {
                        OwnerCar = testOwner,
                        NameCar = "Ford Ranger Wildtrak",
                        LicensePlate = "29C-567.89",
                        TypeCar = "Truck",
                        Seat = 5,
                        Transmission = "Automatic",
                        FuelType = "Diesel",
                        FuelConsumption = 9.0,
                        PricePerDay = 1000000,
                        Location = "Hà Nội",
                        Description = "Vua bán tải, mạnh mẽ, đa dụng.",
                        imageUrls = new List<string> { "https://fordthanglong.com.vn/wp-content/uploads/2023/04/ford-ranger-wildtrak-mau-vang-1.png" },
                        Status = "Available",
                        ModelYear = 2023,
                        Color = "Orange",
                        Deposit = 3000000
                    }
                };
                context.Cars.AddRange(cars);
                context.SaveChanges();
                */
                Console.WriteLine("✅ Seeding completed.");
            }
        }
    }
}
