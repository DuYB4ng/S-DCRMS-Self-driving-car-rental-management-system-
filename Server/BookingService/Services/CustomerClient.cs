using System.Net.Http.Json;

namespace BookingService.Services
{
    public class CustomerClient
    {
        private readonly HttpClient _httpClient;

        public CustomerClient(HttpClient httpClient, IConfiguration config)
        {
            _httpClient = httpClient;

            // Gọi trực tiếp service trong docker
            var baseUrl = config["Services:CustomerService"];
            _httpClient.BaseAddress = new Uri(baseUrl!);
        }

        public async Task<CustomerDto?> GetByFirebaseUidAsync(string firebaseUid)
        {
            // nếu BaseAddress = "http://customerservice:8085"
            var response = await _httpClient.GetAsync($"/api/customer/by-firebase/{firebaseUid}");
            if (!response.IsSuccessStatusCode) return null;

            return await response.Content.ReadFromJsonAsync<CustomerDto>();
        }

        public async Task<CustomerDto?> GetByIdAsync(int id)
        {
            var response = await _httpClient.GetAsync($"/api/customer/{id}");
            if (!response.IsSuccessStatusCode) return null;

            return await response.Content.ReadFromJsonAsync<CustomerDto>();
        }
    }

    // DTO tối thiểu để BookingService dùng
    public class CustomerDto
    {
        public int CustomerId { get; set; }
        public string FirebaseUid { get; set; } = string.Empty;
        public string? FullName { get; set; }
    }
}
