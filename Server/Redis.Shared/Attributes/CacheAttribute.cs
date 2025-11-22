using System;

namespace Redis.Shared.Attributes
{
    [AttributeUsage(AttributeTargets.Method)]
    public class CacheAttribute : Attribute
    {
        public int TTLSeconds { get; }
        public CacheAttribute(int ttlSeconds = -1) => TTLSeconds = ttlSeconds;
    }
}
