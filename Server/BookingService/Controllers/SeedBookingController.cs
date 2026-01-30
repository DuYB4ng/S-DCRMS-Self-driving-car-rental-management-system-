using BookingService.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;
using System.Net.Http;
using Microsoft.Extensions.Configuration;

namespace BookingService.Controllers
{
    [ApiController]
    [Route("api/seed-bookings")]
    public class SeedBookingController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly IConfiguration _configuration;

        public SeedBookingController(AppDbContext context, IHttpClientFactory httpClientFactory, IConfiguration configuration)
        {
            _context = context;
            _httpClientFactory = httpClientFactory;
            _configuration = configuration;
        }

        [HttpPost("demo")]
        public async Task<IActionResult> SeedDemoBookings()
        {
            // 1. Fetch Users to find tmp2@gmail.com
             var userServiceUrl = _configuration["Services:UserService"] ?? "http://userservice:8086";
             var ownerServiceUrl = _configuration["Services:OwnerCarService"] ?? "http://ownercarservice:8081";
             var client = _httpClientFactory.CreateClient();

             UserDto customer = null;
             try 
             {
                 var response = await client.GetAsync($"{userServiceUrl}/api/users/email/tmp2@gmail.com");
                 if (response.IsSuccessStatusCode)
                 {
                     var json = await response.Content.ReadAsStringAsync();
                     customer = JsonSerializer.Deserialize<UserDto>(json, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                 }
                 else
                 {
                     // Fallback check all users list if email endpoint fails
                      var allRes = await client.GetAsync($"{userServiceUrl}/api/users");
                      var json = await allRes.Content.ReadAsStringAsync();
                      var users = JsonSerializer.Deserialize<List<UserDto>>(json, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                      customer = users?.FirstOrDefault(u => u.Email == "tmp2@gmail.com");
                 }
             }
             catch (Exception ex) 
             {
                 return BadRequest("Could not fetch customer: " + ex.Message);
             }

             if (customer == null) return BadRequest("Customer tmp2@gmail.com not found");

             // 2. Fetch Cars to have valid CarIDs
             List<CarDto> cars = new List<CarDto>();
             try
             {
                 var res = await client.GetAsync($"{ownerServiceUrl}/api/cars");
                 var json = await res.Content.ReadAsStringAsync();
                 cars = JsonSerializer.Deserialize<List<CarDto>>(json, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
             }
             catch
             {
                 return BadRequest("Could not fetch cars");
             }

             if (cars == null || !cars.Any()) return BadRequest("No cars found to book");

             // 3. Create Bookings
             // Create past bookings for stats
             var random = new Random();
             var statuses = new[] { "Completed", "Completed", "Completed", "Cancelled", "InProgress" };
             
             var bookings = new List<Booking>();

             for (int i = 0; i < 10; i++)
             {
                 var car = cars[random.Next(cars.Count)];
                 var days = random.Next(1, 5);
                 var totalPrice = car.PricePerDay * days;
                 var status = statuses[random.Next(statuses.Length)];

                 // Distribute dates over last month
                 var pastDays = random.Next(1, 30);
                 var startDate = DateTime.Now.AddDays(-pastDays);
                 var endDate = startDate.AddDays(days);

                 bookings.Add(new Booking
                 {
                     CarId = car.CarID,
                     CustomerId = customer.Id, // Assuming Booking uses Integer ID for Customer
                     StartDate = startDate,
                     EndDate = endDate,
                     TotalPrice = totalPrice,
                     Status = status,
                     CreatedAt = startDate.AddDays(-1) // Booked 1 day before
                 });
             }

             _context.Bookings.AddRange(bookings);
             await _context.SaveChangesAsync();

             return Ok("Bookings Seeded");
        }

        public class UserDto { public int Id { get; set; } public string Email { get; set; } }
        public class CarDto { public int CarID { get; set; } public decimal PricePerDay { get; set; } }
    }
}
