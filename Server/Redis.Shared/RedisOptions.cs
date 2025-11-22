namespace Redis.Shared
{
    public class RedisOptions
    {
        public string ConnectionString { get; set; } = default!;
        public int DefaultTTLSeconds { get; set; } = 300;
        public bool EnableAutoCache { get; set; } = true;
    }
}
