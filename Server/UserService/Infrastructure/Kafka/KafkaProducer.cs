using Confluent.Kafka;
using System.Text.Json;

public interface IKafkaProducer
{
    Task ProduceAsync<T>(string topic, string key, T message);
}

public class KafkaProducer : IKafkaProducer
{
    private  IProducer<string, string>? _producer;
    private readonly ProducerConfig _conf;

    public KafkaProducer(IConfiguration config)
    {
        _conf = new ProducerConfig
        {
            BootstrapServers = config["Kafka:BootstrapServers"]
        };
    }

    private IProducer<string, string> GetProducer()
    {
        if (_producer == null) {
            try {
                 _producer = new ProducerBuilder<string, string>(_conf).Build();
            } catch(Exception ex) {
                 Console.WriteLine($"[KafkaProducer] Init failed: {ex.Message}");
                 throw;
            }
        }
        return _producer;
    }


    public async Task ProduceAsync<T>(string topic, string key, T message)
    {
        var json = JsonSerializer.Serialize(message);

        try
        {
            await GetProducer().ProduceAsync(topic, new Message<string, string>
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
