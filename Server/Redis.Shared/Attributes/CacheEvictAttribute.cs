using System;

namespace Redis.Shared.Attributes
{
    [AttributeUsage(AttributeTargets.Method)]
    public class CacheEvictAttribute : Attribute
    {
        public string Pattern { get; }
        public CacheEvictAttribute(string pattern) => Pattern = pattern;
    }
}
