using Confluent.Kafka;
using System.Text.Json;

namespace OwnerCarService.Services
{
    public class KafkaProducer : IDisposable
    {
        private readonly IProducer<Null, string> _producer;

        public KafkaProducer(IConfiguration configuration)
        {
            var kafkaSection = configuration.GetSection("Kafka");
            var bootstrapServers = kafkaSection["BootstrapServers"] ?? "localhost:9092";

            var config = new ProducerConfig
            {
                BootstrapServers = bootstrapServers,
                Acks = Acks.All
            };

            _producer = new ProducerBuilder<Null, string>(config).Build();
        }

        public async Task SendMessageAsync<T>(string topic, T message)
        {
            var json = JsonSerializer.Serialize(message);

            try
            {
                var result = await _producer.ProduceAsync(
                    topic,
                    new Message<Null, string> { Value = json });

                Console.WriteLine($"✅ Sent message to {result.TopicPartitionOffset}: {json}");
            }
            catch (ProduceException<Null, string> ex)
            {
                Console.WriteLine($"❌ Delivery failed: {ex.Error.Reason}");
                throw;
            }
        }

        public void Dispose() => _producer.Dispose();
    }
}
