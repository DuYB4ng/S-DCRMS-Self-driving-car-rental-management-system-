using Microsoft.AspNetCore.Mvc;
using OwnerCarService.Models;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;
using System.Net.Http;
using Microsoft.Extensions.Configuration;

namespace OwnerCarService.Controllers
{
    [ApiController]
    [Route("api/seed")]
    public class SeedController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly IConfiguration _configuration;

        public SeedController(AppDbContext context, IHttpClientFactory httpClientFactory, IConfiguration configuration)
        {
            _context = context;
            _httpClientFactory = httpClientFactory;
            _configuration = configuration;
        }

        [HttpPost("demo-data")]
        public async Task<IActionResult> SeedDemoData()
        {
            // 1. Clear existing Cars
            var allCars = await _context.Cars.ToListAsync();
            _context.Cars.RemoveRange(allCars);
            await _context.SaveChangesAsync();
            
            // 2. Clear existing OwnerCars (optional, but good for clean start)
            // Note: If we clear owners, we must ensure we get their IDs right again.
            // Let's just Get or Create Owners based on Email lookup from UserService.

            // Fetch Users from UserService
            var userServiceUrl = _configuration["Services:UserService"] ?? "http://userservice:8086";
            var client = _httpClientFactory.CreateClient();
            
            List<UserDto> users = new List<UserDto>();
            try 
            {
                var response = await client.GetAsync($"{userServiceUrl}/api/users");
                if (response.IsSuccessStatusCode)
                {
                    var json = await response.Content.ReadAsStringAsync();
                    users = JsonSerializer.Deserialize<List<UserDto>>(json, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                }
            }
            catch(Exception ex)
            {
                return BadRequest($"Failed to fetch users: {ex.Message}");
            }

            if (users == null || !users.Any()) return BadRequest("No users found in UserService");

            // Define Target Owners
            var targets = new [] 
            { 
                new { Email = "chuxe1@gmail.com", Location = "Hồ Chí Minh", Cars = new [] 
                    {
                        new { Name = "Mercedes-Benz GLC 300", Plate = "30E-922.91", Price = 2500000, Seat = 5, Type = "SUV", Color="Black", Img = "https://i.imgur.com/example1.jpg" }, // Will update img later or use placehold
                        new { Name = "Kia Cerato", Plate = "18A-123.45", Price = 800000, Seat = 4, Type = "Sedan", Color="Green", Img = "https://i.imgur.com/example2.jpg" }
                    }
                },
                new { Email = "chuxe2@gmail.com", Location = "Đà Nẵng", Cars = new [] 
                    {
                        new { Name = "Mazda CX-5", Plate = "43A-567.89", Price = 1200000, Seat = 5, Type = "SUV", Color="White", Img = "" },
                        new { Name = "Hyundai Accent", Plate = "43A-112.23", Price = 700000, Seat = 4, Type = "Sedan", Color="Red", Img = "" }
                    }
                },
                new { Email = "chuxe3@gmail.com", Location = "Hà Nội", Cars = new [] 
                    {
                        new { Name = "VinFast Lux A2.0", Plate = "30H-999.99", Price = 1500000, Seat = 5, Type = "Sedan", Color="Grey", Img = "" },
                        new { Name = "Toyota Innova", Plate = "29A-444.55", Price = 900000, Seat = 7, Type = "MPV", Color="Silver", Img = "" }
                    }
                }
            };

            foreach (var target in targets)
            {
                var user = users.FirstOrDefault(u => u.Email.Equals(target.Email, StringComparison.OrdinalIgnoreCase));
                if (user != null)
                {
                    // Find or Create OwnerCar record
                    var owner = await _context.OwnerCars.FirstOrDefaultAsync(o => o.FirebaseUid == user.FirebaseUid);
                    if (owner == null)
                    {
                        owner = new OwnerCar
                        {
                            FirebaseUid = user.FirebaseUid,
                            DrivingLicence = "DL-" + user.Id,
                            LicenceIssueDate = DateTime.Now.AddYears(-2),
                            LicenceExpiryDate = DateTime.Now.AddYears(8),
                            IsActive = true
                        };
                        _context.OwnerCars.Add(owner);
                        await _context.SaveChangesAsync();
                    }

                    // Add Cars
                    foreach (var carInfo in target.Cars)
                    {
                        var car = new Car
                        {
                            OwnerCarID = owner.OwnerCarId,
                            NameCar = carInfo.Name,
                            LicensePlate = carInfo.Plate,
                            PricePerDay = carInfo.Price,
                            Seat = carInfo.Seat,
                            TypeCar = carInfo.Type,
                            Color = carInfo.Color,
                            Location = target.Location,
                            Description = $"Xe {carInfo.Name} tại {target.Location}",
                            Status = "Available",
                            ModelYear = 2023,
                            Transmission = "Automatic",
                            FuelType = "Gasoline",
                            FuelConsumption = 8,
                            Deposit = 500000 * carInfo.Seat,
                            RegistrationDate = DateTime.Now.AddYears(-1),
                            InsuranceExpiryDate = DateTime.Now.AddYears(1),
                            InspectionExpiryDate = DateTime.Now.AddYears(1),
                            imageUrls = new List<string> { "https://via.placeholder.com/400x300.png?text=" + Uri.EscapeDataString(carInfo.Name) }
                        };
                        
                        // Update specific images if requested
                        if (carInfo.Plate == "30E-922.91") car.imageUrls = new List<string> { "https://i.imgur.com/example1.jpg" }; // Replace with real uploaded logic if possible, currently using placeholder
                        if (carInfo.Plate == "18A-123.45") car.imageUrls = new List<string> { "https://i.imgur.com/example2.jpg" };

                        _context.Cars.Add(car);
                    }
                }
            }

            await _context.SaveChangesAsync();
            return Ok("Seeding Completed");
        }

        public class UserDto
        {
            public int Id { get; set; }
            public string FirebaseUid { get; set; }
            public string Email { get; set; }
        }
    }
}
