using StackExchange.Redis;
using System.Text.Json;

namespace Redis.Shared
{
    public class RedisCacheService : IRedisCacheService
    {
        private readonly IDatabase _db;
        private readonly IConnectionMultiplexer _redis;

        public RedisCacheService(RedisOptions options)
        {
            _redis = ConnectionMultiplexer.Connect(options.ConnectionString);
            _db = _redis.GetDatabase();
            Console.WriteLine($"🔗 Connected to Redis at {options.ConnectionString}");
        }

        public async Task<T?> GetAsync<T>(string key)
        {
            var value = await _db.StringGetAsync(key);
            if (!value.IsNullOrEmpty)
                Console.WriteLine($"✅ Redis GET key='{key}' hit, type={typeof(T).Name}");
            else
                Console.WriteLine($"❌ Redis GET key='{key}' miss");
            return value.IsNullOrEmpty ? default : JsonSerializer.Deserialize<T>(value!);
        }

        public async Task SetAsync<T>(string key, T value, int ttlSeconds)
        {
            var json = JsonSerializer.Serialize(value);
            await _db.StringSetAsync(key, json, TimeSpan.FromSeconds(ttlSeconds));
            Console.WriteLine($"💾 Redis SET key='{key}', TTL={ttlSeconds}s, type={typeof(T).Name}");
        }

        public async Task RemoveByPatternAsync(string pattern)
        {
            Console.WriteLine($"🗑️ Redis REMOVE pattern='{pattern}'");
            foreach (var endPoint in _redis.GetEndPoints())
            {
                var server = _redis.GetServer(endPoint);
                foreach (var key in server.Keys(pattern: pattern))
                {
                    await _db.KeyDeleteAsync(key);
                    Console.WriteLine($"🗑️ Deleted key='{key}'");
                }
            }
        }
        public async Task<T> GetOrSetAsync<T>(string key, Func<Task<T>> factory, int ttlSeconds)
        {
            var cached = await GetAsync<T>(key);
            if (cached != null) return cached;

            var value = await factory();
            await SetAsync(key, value!, ttlSeconds);
            return value;
        }

    }
}
