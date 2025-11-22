using FirebaseAdmin;
using FirebaseAdmin.Messaging;
using Google.Apis.Auth.OAuth2;
using Microsoft.EntityFrameworkCore;
using SDCRMS.Data;

namespace SDCRMS.Services
{
    public interface IFCMService
    {
        Task<string> SendNotificationToTokenAsync(
            string token,
            string title,
            string body,
            Dictionary<string, string>? data = null
        );
    }

    public class FCMService : IFCMService
    {
        private readonly AdminDbContext _context;
        private readonly ILogger<FCMService> _logger;
        private readonly FirebaseMessaging _messaging;

        public FCMService(
            AdminDbContext context,
            ILogger<FCMService> logger,
            IConfiguration configuration
        )
        {
            _context = context;
            _logger = logger;

            // Khởi tạo Firebase Admin SDK
            var credentialPath = configuration["Firebase:ServiceAccountKeyPath"];

            if (FirebaseApp.DefaultInstance == null && !string.IsNullOrEmpty(credentialPath))
            {
                try
                {
                    FirebaseApp.Create(
                        new AppOptions() { Credential = GoogleCredential.FromFile(credentialPath) }
                    );
                    _logger.LogInformation("Firebase Admin SDK initialized successfully");
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Failed to initialize Firebase Admin SDK");
                }
            }

            _messaging = FirebaseMessaging.DefaultInstance;
        }

        // Method removed: SendNotificationAsync (FCMTokens not available in AdminDbContext)

        /// <summary>
        /// Gửi notification đến một token cụ thể
        /// </summary>
        public async Task<string> SendNotificationToTokenAsync(
            string token,
            string title,
            string body,
            Dictionary<string, string>? data = null
        )
        {
            try
            {
                var message = new Message()
                {
                    Token = token,
                    Notification = new FirebaseAdmin.Messaging.Notification
                    {
                        Title = title,
                        Body = body,
                    },
                    Data = data,
                    Android = new AndroidConfig()
                    {
                        Priority = Priority.High,
                        Notification = new AndroidNotification()
                        {
                            ChannelId = "default",
                            Sound = "default",
                        },
                    },
                    Apns = new ApnsConfig()
                    {
                        Aps = new Aps() { Sound = "default", Badge = 1 },
                    },
                };

                var response = await _messaging.SendAsync(message);
                _logger.LogInformation($"Successfully sent message: {response}");
                return response;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending FCM notification to token");
                throw;
            }
        }

        // Method removed: SendBroadcastNotificationAsync (FCMTokens not available in AdminDbContext)
    }
}
