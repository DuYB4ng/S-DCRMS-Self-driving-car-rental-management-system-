using Confluent.Kafka;
using Infrastructure.Kafka.Messages;
using System.Text.Json;
using UserService.Services;

public class UserLocationConsumer : BackgroundService
{
    private readonly IServiceScopeFactory _scopeFactory;

    public UserLocationConsumer(IServiceScopeFactory scopeFactory)
    {
        _scopeFactory = scopeFactory;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        var conf = new ConsumerConfig
        {
            BootstrapServers = "kafka:9092",
            GroupId = "user-location-consumer",
            AutoOffsetReset = AutoOffsetReset.Latest,
            EnableAutoCommit = true
        };

        IConsumer<string, string> consumer = null;

        // Retry loop for initialization
        while (consumer == null && !stoppingToken.IsCancellationRequested)
        {
            try
            {
                consumer = new ConsumerBuilder<string, string>(conf).Build();
                consumer.Subscribe("user-location");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Kafka init failed: {ex.Message}. Retrying in 5s...");
                await Task.Delay(5000, stoppingToken);
            }
        }


        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                var cr = consumer.Consume(stoppingToken);
                if (cr?.Message == null) continue;

                var msg = JsonSerializer.Deserialize<UserLocationMessage>(cr.Message.Value);
                if (msg == null) continue;

                using var scope = _scopeFactory.CreateScope();
                var userService = scope.ServiceProvider.GetRequiredService<IUserService>();

                var user = await userService.GetByFirebaseUidAsync(msg.FirebaseUid);
                if (user == null) continue;

                user.Latitude = msg.Latitude;
                user.Longitude = msg.Longitude;
                user.LocationUpdatedAt = msg.Timestamp;

                await userService.UpdateUserAsync(user);
            }
            catch (ConsumeException ex)
            {
                Console.WriteLine($"Kafka consume error: {ex.Error.Reason}");
                await Task.Delay(3000, stoppingToken); // ⬅ KHÔNG CHO APP DIE
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Consumer error: {ex}");
                await Task.Delay(3000, stoppingToken);
            }
        }
    }
}
