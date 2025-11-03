// using Confluent.Kafka;
// using Microsoft.EntityFrameworkCore;
// using OwnerCarService.Models;
// using System.Text.Json;

// namespace OwnerCarService.Services
// {
//     public class KafkaConsumerService : BackgroundService
//     {
//         private readonly ILogger<KafkaConsumerService> _logger;
//         private readonly IServiceScopeFactory _scopeFactory;
//         private readonly string _bootstrapServers;
//         private readonly string _topic = "car_location";
//         private readonly string _groupId = "owner-car-consumer-group";

//         public KafkaConsumerService(ILogger<KafkaConsumerService> logger, IConfiguration config, IServiceScopeFactory scopeFactory)
//         {
//             _logger = logger;
//             _scopeFactory = scopeFactory;
//             _bootstrapServers = config["KAFKA__BootstrapServers"] ?? "localhost:9092";
//         }

//         protected override async Task ExecuteAsync(CancellationToken stoppingToken)
//         {
//             var config = new ConsumerConfig
//             {
//                 BootstrapServers = _bootstrapServers,
//                 GroupId = _groupId,
//                 AutoOffsetReset = AutoOffsetReset.Earliest,
//                 EnableAutoCommit = true
//             };

//             using var consumer = new ConsumerBuilder<Ignore, string>(config).Build();
//             consumer.Subscribe(_topic);

//             _logger.LogInformation("🚗 KafkaConsumerService started, listening on topic: {Topic}", _topic);

//             try
//             {
//                 while (!stoppingToken.IsCancellationRequested)
//                 {
//                     try
//                     {
//                         var cr = consumer.Consume(stoppingToken);
//                         if (cr?.Message?.Value == null) continue;

//                         _logger.LogInformation("📩 Received message: {Message}", cr.Message.Value);

//                         var dto = JsonSerializer.Deserialize<CarLocation>(cr.Message.Value);
//                         if (dto == null) continue;

//                         using var scope = _scopeFactory.CreateScope();
//                         var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();

//                         db.CarLocations.Add(dto);
//                         await db.SaveChangesAsync(stoppingToken);

//                         _logger.LogInformation("💾 Saved CarLocation: CarID={CarID}, Speed={Speed}", dto.CarID, dto.Speed);
//                     }
//                     catch (ConsumeException e)
//                     {
//                         _logger.LogError("❌ Consume error: {Error}", e.Error.Reason);
//                     }
//                     catch (JsonException je)
//                     {
//                         _logger.LogError("❌ JSON parse error: {Message}", je.Message);
//                     }
//                 }
//             }
//             catch (OperationCanceledException)
//             {
//                 _logger.LogWarning("🛑 KafkaConsumerService stopped by cancellation.");
//             }
//             finally
//             {
//                 consumer.Close();
//             }
//         }
//     }
// }
