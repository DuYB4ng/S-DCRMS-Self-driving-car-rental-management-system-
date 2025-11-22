using Castle.DynamicProxy;
using Redis.Shared.Attributes;
using System;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;

namespace Redis.Shared.Interceptors
{
    public class RedisCacheInterceptorAsync : IAsyncInterceptor
    {
        private readonly IRedisCacheService _cache;
        private readonly RedisOptions _options;

        public RedisCacheInterceptorAsync(IRedisCacheService cache, RedisOptions options)
        {
            _cache = cache;
            _options = options;
        }

        // Dành cho các method đồng bộ
        public void InterceptSynchronous(IInvocation invocation)
        {
            invocation.Proceed();
        }

        // Dành cho các method trả Task (không có giá trị)
        public void InterceptAsynchronous(IInvocation invocation)
        {
            invocation.ReturnValue = InterceptAsyncInternal(invocation);
        }

        // Dành cho các method trả Task<TResult>
        public void InterceptAsynchronous<TResult>(IInvocation invocation)
        {
            invocation.ReturnValue = InterceptAsyncInternal<TResult>(invocation);
        }

        private async Task InterceptAsyncInternal(IInvocation invocation)
        {
            var (cacheAttr, evictAttr) = GetAttributes(invocation);
            string key = BuildKey(invocation);

            if (cacheAttr != null && _options.EnableAutoCache)
            {
                // Chỉ định rõ kiểu là object để tránh lỗi CS0411
                await _cache.GetOrSetAsync<object>(
                    key,
                    async () =>
                    {
                        invocation.Proceed();
                        await (Task)invocation.ReturnValue;
                        return null!;
                    },
                    cacheAttr.TTLSeconds > 0 ? cacheAttr.TTLSeconds : _options.DefaultTTLSeconds
                );
            }
            else
            {
                invocation.Proceed();
                await (Task)invocation.ReturnValue;
            }

            if (evictAttr != null)
                await _cache.RemoveByPatternAsync(evictAttr.Pattern);
        }

        private async Task<TResult> InterceptAsyncInternal<TResult>(IInvocation invocation)
        {
            var (cacheAttr, evictAttr) = GetAttributes(invocation);
            string key = BuildKey(invocation);

            if (cacheAttr != null && _options.EnableAutoCache)
            {
                var cached = await _cache.GetOrSetAsync<TResult>(
                    key,
                    async () =>
                    {
                        invocation.Proceed();
                        var result = await (Task<TResult>)invocation.ReturnValue;
                        return result!;
                    },
                    cacheAttr.TTLSeconds > 0 ? cacheAttr.TTLSeconds : _options.DefaultTTLSeconds
                );

                if (evictAttr != null)
                    await _cache.RemoveByPatternAsync(evictAttr.Pattern);

                return cached;
            }
            else
            {
                invocation.Proceed();
                var finalResult = await (Task<TResult>)invocation.ReturnValue;

                if (evictAttr != null)
                    await _cache.RemoveByPatternAsync(evictAttr.Pattern);

                return finalResult;
            }
        }

        private (CacheAttribute?, CacheEvictAttribute?) GetAttributes(IInvocation invocation)
        {
            var method = invocation.MethodInvocationTarget ?? invocation.Method;

            var cacheAttr = method.GetCustomAttributes(typeof(CacheAttribute), true)
                                  .FirstOrDefault() as CacheAttribute
                              ?? invocation.Method.GetCustomAttributes(typeof(CacheAttribute), true)
                                  .FirstOrDefault() as CacheAttribute;

            var evictAttr = method.GetCustomAttributes(typeof(CacheEvictAttribute), true)
                                  .FirstOrDefault() as CacheEvictAttribute
                              ?? invocation.Method.GetCustomAttributes(typeof(CacheEvictAttribute), true)
                                  .FirstOrDefault() as CacheEvictAttribute;

            return (cacheAttr, evictAttr);
        }

        private string BuildKey(IInvocation invocation)
        {
            var className = invocation.TargetType.Name;
            var methodName = invocation.Method.Name;

            if (invocation.Arguments == null || invocation.Arguments.Length == 0)
                return $"{className}:{methodName}";

            var argsPart = string.Join("_", invocation.Arguments.Select(a =>
            {
                try
                {
                    return JsonSerializer.Serialize(a);
                }
                catch
                {
                    return a?.ToString() ?? "null";
                }
            }));

            return $"{className}:{methodName}:{argsPart}";
        }
    }
}
