using Confluent.Kafka;
using System.Text.Json;

public interface IKafkaProducer
{
    Task ProduceAsync<T>(string topic, string key, T message);
}

public class KafkaProducer : IKafkaProducer
{
    private readonly IProducer<string, string> _producer;

    public KafkaProducer(IConfiguration config)
    {
        var conf = new ProducerConfig
        {
            BootstrapServers = config["Kafka:BootstrapServers"]
        };

        _producer = new ProducerBuilder<string, string>(conf).Build();
    }

    public async Task ProduceAsync<T>(string topic, string key, T message)
    {
        var json = JsonSerializer.Serialize(message);

        try
        {
            await _producer.ProduceAsync(topic, new Message<string, string>
            {
                Key = key,
                Value = json
            });
        }
        catch (ProduceException<string, string> ex)
        {
            Console.WriteLine(
                $"[KafkaProducer] Produce failed | Topic: {topic} | Reason: {ex.Error.Reason}"
            );
        }
        catch (Exception ex)
        {
            Console.WriteLine(
                $"[KafkaProducer] Unexpected error: {ex.Message}"
            );
        }
    }

}
