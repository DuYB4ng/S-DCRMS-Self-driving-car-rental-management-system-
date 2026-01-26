using System.Net.Http.Json;

namespace BookingService.Services
{
    public class UserClient
    {
        private readonly HttpClient _httpClient;

        public UserClient(HttpClient httpClient, IConfiguration config)
        {
            _httpClient = httpClient;
            var baseUrl = config["Services:UserService"];
            _httpClient.BaseAddress = new Uri(baseUrl ?? "http://localhost:5001");
        }

        public async Task<bool> DeductWalletAsync(string firebaseUid, decimal amount)
        {
            var response = await _httpClient.PostAsJsonAsync("/api/wallet/deduct", new { FirebaseUid = firebaseUid, Amount = amount });
            return response.IsSuccessStatusCode;
        }

        public async Task<bool> CreditWalletAsync(string firebaseUid, decimal amount)
        {
            var response = await _httpClient.PostAsJsonAsync("/api/wallet/topup", new { FirebaseUid = firebaseUid, Amount = amount });
            return response.IsSuccessStatusCode;
        }
    }
}
