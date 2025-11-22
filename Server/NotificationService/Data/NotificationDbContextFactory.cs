using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.Configuration;
using SDCRMS.Data;

namespace SDCRMS.Data
{
    public class NotificationDbContextFactory : IDesignTimeDbContextFactory<NotificationDbContext>
    {
        public NotificationDbContext CreateDbContext(string[] args)
        {
            // Build configuration
            var configuration = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                .AddJsonFile("appsettings.Development.json", optional: true, reloadOnChange: true)
                .Build();

            // Get connection string
            var connectionString = configuration.GetConnectionString("AdminServiceConnection");

            if (string.IsNullOrEmpty(connectionString))
            {
                throw new InvalidOperationException(
                    "Connection string 'AdminServiceConnection' not found in appsettings.json"
                );
            }

            var optionsBuilder = new DbContextOptionsBuilder<NotificationDbContext>();
            optionsBuilder.UseSqlServer(
                connectionString,
                sqlOptions =>
                {
                    sqlOptions.EnableRetryOnFailure(
                        maxRetryCount: 5,
                        maxRetryDelay: TimeSpan.FromSeconds(30),
                        errorNumbersToAdd: null
                    );
                }
            );

            return new NotificationDbContext(optionsBuilder.Options);
        }
    }
}
