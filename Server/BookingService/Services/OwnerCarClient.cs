using System.Net.Http.Json;

namespace BookingService.Services
{
    public class OwnerCarClient
    {
        private readonly HttpClient _httpClient;

        public OwnerCarClient(HttpClient httpClient, IConfiguration config)
        {
            _httpClient = httpClient;
            var baseUrl = config["Services:OwnerCarService"]; 
            _httpClient.BaseAddress = new Uri(baseUrl ?? "http://localhost:5002");
        }

        public async Task<int?> GetOwnerIdByCarIdAsync(int carId)
        {
             var response = await _httpClient.GetAsync($"/api/car/{carId}");
             if (!response.IsSuccessStatusCode) return null;
             
             var car = await response.Content.ReadFromJsonAsync<CarDtoMinimal>();
             return car?.OwnerCarID;
        }

        public async Task<string?> GetOwnerFirebaseUidAsync(int ownerCarId)
        {
             var response = await _httpClient.GetAsync($"/api/ownercar/{ownerCarId}");
             if (!response.IsSuccessStatusCode) return null;
             
             var owner = await response.Content.ReadFromJsonAsync<OwnerCarDtoMinimal>();
             return owner?.FirebaseUid;
        }

        private class CarDtoMinimal { public int OwnerCarID { get; set; } }
        private class OwnerCarDtoMinimal { public string FirebaseUid { get; set; } }
    }
}
