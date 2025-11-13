using Microsoft.EntityFrameworkCore;

namespace OwnerCarConsumer.Services
{
    public class MigrationHostedService : IHostedService
    {
        private readonly IServiceProvider _serviceProvider;
        private readonly ILogger<MigrationHostedService> _logger;

        public MigrationHostedService(IServiceProvider serviceProvider, ILogger<MigrationHostedService> logger)
        {
            _serviceProvider = serviceProvider;
            _logger = logger;
        }

        public async Task StartAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("🗄️ Running EF Core migrations...");

            try
            {
                using var scope = _serviceProvider.CreateScope();
                var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();

                await db.Database.MigrateAsync(cancellationToken);

                _logger.LogInformation("✅ Migration completed successfully.");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "❌ Migration failed.");
                throw; // Cho container fail sớm để Docker restart (tự recovery)
            }
        }

        public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
    }
}
