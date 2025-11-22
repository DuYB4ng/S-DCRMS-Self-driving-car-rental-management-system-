namespace Redis.Shared
{
    public interface IRedisCacheService
    {
        Task<T?> GetAsync<T>(string key);
        Task SetAsync<T>(string key, T value, int ttlSeconds);
        Task RemoveByPatternAsync(string pattern);

        // Thêm method mới
        Task<T> GetOrSetAsync<T>(string key, Func<Task<T>> factory, int ttlSeconds);
    }
}
