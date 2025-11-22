using Castle.DynamicProxy;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Redis.Shared.Interceptors;

namespace Redis.Shared.Extensions
{
    public static class RedisSharedExtensions
    {
        public static IServiceCollection AddRedisShared(this IServiceCollection services, IConfiguration config)
        {
            var options = config.GetSection("Redis").Get<RedisOptions>() ?? new RedisOptions();
            services.AddSingleton(options);

            services.AddSingleton<IRedisCacheService, RedisCacheService>();
            services.AddSingleton<IProxyGenerator, ProxyGenerator>();
            services.AddSingleton<RedisCacheInterceptorAsync>();

            return services;
        }

        public static IServiceCollection AddProxiedService<TInterface, TImplementation>(this IServiceCollection services)
            where TInterface : class
            where TImplementation : class, TInterface
        {
            services.AddTransient<TImplementation>();
            services.AddTransient(provider =>
            {
                var target = provider.GetRequiredService<TImplementation>();
                var proxyGenerator = provider.GetRequiredService<IProxyGenerator>();
                var interceptor = provider.GetRequiredService<RedisCacheInterceptorAsync>();

                return proxyGenerator.CreateInterfaceProxyWithTarget<TInterface>(target, interceptor);
            });

            return services;
        }
    }
}
