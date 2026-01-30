using BookingService.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;
using System.Net.Http;
using Microsoft.Extensions.Configuration;

namespace BookingService.Controllers
{
    [ApiController]
    [Route("api/seed-v3")]
    public class SeedBookingControllerV3 : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly IConfiguration _configuration;

        public SeedBookingControllerV3(AppDbContext context, IHttpClientFactory httpClientFactory, IConfiguration configuration)
        {
            _context = context;
            _httpClientFactory = httpClientFactory;
            _configuration = configuration;
        }

        [HttpPost("demo")]
        public async Task<IActionResult> SeedDemoBookings()
        {
             var debugInfo = new List<string>();
             debugInfo.Add("Starting seed V3...");

            // 1. Fetch Users
             var userServiceUrl = _configuration["Services:UserService"] ?? "http://userservice:8086";
             var ownerServiceUrl = _configuration["Services:OwnerCarService"] ?? "http://ownercarservice:8081";
             
             debugInfo.Add($"UserServiceUrl: {userServiceUrl}");
             debugInfo.Add($"OwnerCarServiceUrl: {ownerServiceUrl}");

             var client = _httpClientFactory.CreateClient();

             UserDto customer = null;
             try 
             {
                 var url = $"{userServiceUrl}/api/users/email/tmp2@gmail.com";
                 debugInfo.Add($"Fetching user from: {url}");
                 var response = await client.GetAsync(url);
                 if (response.IsSuccessStatusCode)
                 {
                     var json = await response.Content.ReadAsStringAsync();
                     customer = JsonSerializer.Deserialize<UserDto>(json, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                     debugInfo.Add($"User found via email: ID={customer?.Id}");
                 }
                 else
                 {
                      debugInfo.Add($"User email lookup failed: {response.StatusCode}. Trying fallback...");
                      var allRes = await client.GetAsync($"{userServiceUrl}/api/users");
                      var json = await allRes.Content.ReadAsStringAsync();
                      var users = JsonSerializer.Deserialize<List<UserDto>>(json, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                      customer = users?.FirstOrDefault(u => u.Email == "tmp2@gmail.com");
                      debugInfo.Add($"User found via fallback: {customer != null}, ID={customer?.Id}");
                 }
             }
             catch (Exception ex) 
             {
                 return BadRequest(new { Message = "Could not fetch customer: " + ex.Message, Debug = debugInfo });
             }

             if (customer == null) return BadRequest(new { Message = "Customer tmp2@gmail.com not found", Debug = debugInfo });

             // 2. Fetch Cars
             List<CarDto> cars = new List<CarDto>();
             try
             {
                 // CORRECT URL: api/car (singular)
                 var carUrl = $"{ownerServiceUrl}/api/car";
                 debugInfo.Add($"Fetching cars from: {carUrl}");
                 var res = await client.GetAsync(carUrl);
                 if (!res.IsSuccessStatusCode)
                 {
                     debugInfo.Add($"Fetch cars failed: {res.StatusCode}");
                     return BadRequest(new { Message = "Fetch cars failed", Debug = debugInfo });
                 }
                 var json = await res.Content.ReadAsStringAsync();
                 cars = JsonSerializer.Deserialize<List<CarDto>>(json, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                 debugInfo.Add($"Cars found: {cars?.Count}");
             }
             catch (Exception ex)
             {
                 return BadRequest(new { Message = "Could not fetch cars: " + ex.Message, Debug = debugInfo });
             }

             if (cars == null || !cars.Any()) return BadRequest(new { Message = "No cars found to book", Debug = debugInfo });

             // 3. Create Bookings
             var random = new Random();
             var statuses = new[] { "Completed", "Completed", "Completed", "Cancelled", "InProgress" };
             
             var bookings = new List<Booking>();

             for (int i = 0; i < 15; i++)
             {
                 var car = cars[random.Next(cars.Count)];
                 var days = random.Next(1, 5);
                 var totalPrice = car.PricePerDay * days;
                 var status = statuses[random.Next(statuses.Length)];

                 var pastDays = random.Next(1, 30);
                 var startDate = DateTime.Now.AddDays(-pastDays);
                 var endDate = startDate.AddDays(days);

                 bookings.Add(new Booking
                 {
                     CarId = car.CarID,
                     CustomerId = customer.Id,
                     StartDate = startDate,
                     EndDate = endDate,
                     TotalPrice = totalPrice,
                     Status = status,
                     CreatedAt = startDate.AddDays(-1)
                 });
             }

             _context.Bookings.AddRange(bookings);
             await _context.SaveChangesAsync();
             
             debugInfo.Add($"Seeded {bookings.Count} bookings.");

             return Ok(new { Message = "Bookings Seeded V3", Debug = debugInfo });
        }

        public class UserDto { public int Id { get; set; } public string Email { get; set; } }
        public class CarDto { public int CarID { get; set; } public decimal PricePerDay { get; set; } }
    }
}
