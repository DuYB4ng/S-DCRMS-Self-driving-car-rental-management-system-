using Confluent.Kafka;
using System.Text.Json;

namespace OwnerCarService.Services
{
    public class KafkaProducer
    {
        private readonly string _bootstrapServers;

        public KafkaProducer(IConfiguration configuration)
        {
            _bootstrapServers = configuration["KAFKA__BootstrapServers"] ?? "localhost:9092";
        }

        public async Task SendMessageAsync<T>(string topic, T message)
        {
            var config = new ProducerConfig
            {
                BootstrapServers = _bootstrapServers,
                Acks = Acks.All
            };

            using var producer = new ProducerBuilder<Null, string>(config).Build();
            var json = JsonSerializer.Serialize(message);

            try
            {
                var dr = await producer.ProduceAsync(
                    topic,
                    new Message<Null, string> { Value = json }
                );

                Console.WriteLine($"✅ Sent message to {dr.TopicPartitionOffset}: {json}");
            }
            catch (ProduceException<Null, string> e)
            {
                Console.WriteLine($"❌ Delivery failed: {e.Error.Reason}");
            }
        }
    }
}
