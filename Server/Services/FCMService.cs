using FirebaseAdmin;
using FirebaseAdmin.Messaging;
using Google.Apis.Auth.OAuth2;
using Microsoft.EntityFrameworkCore;
using SDCRMS.Data;

namespace SDCRMS.Services
{
    public interface IFCMService
    {
        Task<string> SendNotificationAsync(
            int userId,
            string title,
            string body,
            Dictionary<string, string>? data = null
        );
        Task<string> SendNotificationToTokenAsync(
            string token,
            string title,
            string body,
            Dictionary<string, string>? data = null
        );
        Task<List<string>> SendBroadcastNotificationAsync(
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

        /// <summary>
        /// Gửi notification đến một user cụ thể (tất cả devices của user đó)
        /// </summary>
        public async Task<string> SendNotificationAsync(
            int userId,
            string title,
            string body,
            Dictionary<string, string>? data = null
        )
        {
            try
            {
                // Lấy tất cả active tokens của user
                var tokens = await _context
                    .FCMTokens.Where(t => t.UserID == userId && t.IsActive)
                    .Select(t => t.Token)
                    .ToListAsync();

                if (!tokens.Any())
                {
                    _logger.LogWarning($"No active FCM tokens found for user {userId}");
                    return "No active tokens found";
                }

                var message = new MulticastMessage()
                {
                    Tokens = tokens,
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

                var response = await _messaging.SendEachForMulticastAsync(message);

                _logger.LogInformation(
                    $"Successfully sent {response.SuccessCount}/{tokens.Count} messages to user {userId}"
                );

                // Cập nhật LastUsedAt cho các tokens thành công
                if (response.SuccessCount > 0)
                {
                    var fcmTokens = await _context
                        .FCMTokens.Where(t => t.UserID == userId && t.IsActive)
                        .ToListAsync();

                    foreach (var token in fcmTokens)
                    {
                        token.LastUsedAt = DateTime.UtcNow;
                    }
                    await _context.SaveChangesAsync();
                }

                // Xử lý các token bị lỗi
                if (response.FailureCount > 0)
                {
                    for (int i = 0; i < response.Responses.Count; i++)
                    {
                        if (!response.Responses[i].IsSuccess)
                        {
                            var errorCode = response.Responses[i].Exception?.MessagingErrorCode;
                            if (
                                errorCode == MessagingErrorCode.InvalidArgument
                                || errorCode == MessagingErrorCode.Unregistered
                            )
                            {
                                // Deactivate invalid token
                                var invalidToken = tokens[i];
                                var tokenEntity = await _context
                                    .FCMTokens.Where(t => t.Token == invalidToken)
                                    .FirstOrDefaultAsync();

                                if (tokenEntity != null)
                                {
                                    tokenEntity.IsActive = false;
                                    await _context.SaveChangesAsync();
                                    _logger.LogWarning(
                                        $"Deactivated invalid FCM token for user {userId}"
                                    );
                                }
                            }
                        }
                    }
                }

                return $"Sent to {response.SuccessCount}/{tokens.Count} devices";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error sending FCM notification to user {userId}");
                throw;
            }
        }

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

        /// <summary>
        /// Gửi broadcast notification đến tất cả users có active tokens
        /// </summary>
        public async Task<List<string>> SendBroadcastNotificationAsync(
            string title,
            string body,
            Dictionary<string, string>? data = null
        )
        {
            try
            {
                var allTokens = await _context
                    .FCMTokens.Where(t => t.IsActive)
                    .Select(t => t.Token)
                    .Distinct()
                    .ToListAsync();

                if (!allTokens.Any())
                {
                    _logger.LogWarning("No active FCM tokens found for broadcast");
                    return new List<string> { "No active tokens found" };
                }

                // Firebase có giới hạn 500 tokens per request
                var batches = allTokens.Chunk(500);
                var results = new List<string>();

                foreach (var batch in batches)
                {
                    var message = new MulticastMessage()
                    {
                        Tokens = batch.ToList(),
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

                    var response = await _messaging.SendEachForMulticastAsync(message);
                    results.Add($"Batch: {response.SuccessCount}/{batch.Count()} sent");

                    _logger.LogInformation(
                        $"Broadcast batch: {response.SuccessCount}/{batch.Count()} messages sent"
                    );
                }

                return results;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending broadcast FCM notification");
                throw;
            }
        }
    }
}
