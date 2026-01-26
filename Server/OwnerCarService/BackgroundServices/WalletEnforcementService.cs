using OwnerCarService.Services;
using System.Net.Http.Json;

namespace OwnerCarService.BackgroundServices
{
    public class WalletEnforcementService : BackgroundService
    {
        private readonly IServiceProvider _serviceProvider;
        private readonly ILogger<WalletEnforcementService> _logger;
        private readonly IConfiguration _config;
        private readonly HttpClient _httpClient;

        public WalletEnforcementService(
            IServiceProvider serviceProvider,
            ILogger<WalletEnforcementService> logger,
            IConfiguration config,
            IHttpClientFactory httpClientFactory)
        {
            _serviceProvider = serviceProvider;
            _logger = logger;
            _config = config;
            _httpClient = httpClientFactory.CreateClient();
            var userServiceUrl = _config["Services:UserService"];
            _httpClient.BaseAddress = new Uri(userServiceUrl ?? "http://localhost:5001");
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                _logger.LogInformation("WalletEnforcementService running...");

                try
                {
                    // 1. Get negative owners from UserService
                    var response = await _httpClient.GetAsync("/api/wallet/negative-owners", stoppingToken);
                    if (response.IsSuccessStatusCode)
                    {
                        var negativeUsers = await response.Content.ReadFromJsonAsync<List<UserDtoMinimal>>(cancellationToken: stoppingToken);
                        
                        if (negativeUsers != null && negativeUsers.Any())
                        {
                            using (var scope = _serviceProvider.CreateScope())
                            {
                                var ownerCarService = scope.ServiceProvider.GetRequiredService<IOwnerCarService>();

                                foreach (var user in negativeUsers)
                                {
                                    // 2. Find OwnerCar profile
                                    var ownerCar = await ownerCarService.LayOwnerCarTheoFirebaseUidAsync(user.FirebaseUid);
                                    
                                    if (ownerCar != null && ownerCar.IsActive)
                                    {
                                        _logger.LogWarning($"Locking cars for Owner: {user.FirebaseUid}");
                                        await ownerCarService.KhoaXeCuaOwnerAsync(ownerCar.OwnerCarId);
                                    }
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error in WalletEnforcementService");
                }

                // Run every 24 hours (or shorter for testing)
                await Task.Delay(TimeSpan.FromHours(24), stoppingToken);
            }
        }

        private class UserDtoMinimal { public string FirebaseUid { get; set; } }
    }
}
