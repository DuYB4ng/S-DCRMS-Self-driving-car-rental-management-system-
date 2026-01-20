using OwnerCarService.Models;

namespace OwnerCarService.Data
{
    public static class DbInitializer
    {
        public static void Initialize(AppDbContext context)
        {
            // Update "CityA/B/C" to real Vietnamese cities for better demo experience
            bool hasChanges = false;

            var carsA = context.Cars.Where(c => c.Location == "CityA").ToList();
            if (carsA.Any())
            {
                foreach (var car in carsA) car.Location = "Hồ Chí Minh";
                hasChanges = true;
            }

            var carsB = context.Cars.Where(c => c.Location == "CityB").ToList();
            if (carsB.Any())
            {
                foreach (var car in carsB) car.Location = "Hà Nội";
                hasChanges = true;
            }

            var carsC = context.Cars.Where(c => c.Location == "CityC").ToList();
            if (carsC.Any())
            {
                foreach (var car in carsC) car.Location = "Đà Nẵng";
                hasChanges = true;
            }

            if (hasChanges)
            {
                Console.WriteLine("🔄 Updating mock data locations to real cities...");
                context.SaveChanges();
                Console.WriteLine("✅ Mock data updated.");
            }
        }
    }
}
