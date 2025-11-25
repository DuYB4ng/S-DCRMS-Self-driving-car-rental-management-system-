using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using OwnerCarConsumer;
using OwnerCarConsumer.Services;
using Pomelo.EntityFrameworkCore.MySql;
using Pomelo.EntityFrameworkCore.MySql.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

// Add DbContext (MySQL)
builder.Services.AddDbContext<AppDbContext>(options =>
{
    var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
    var serverVersion = new MySqlServerVersion(new Version(8, 0, 36));

    options.UseMySql(
        connectionString,
        serverVersion,
        mySqlOptions =>
        {
            mySqlOptions.EnableRetryOnFailure(5, TimeSpan.FromSeconds(10), null);
        }
    );
});

// Add hosted service (Kafka consumer)
builder.Services.AddHostedService<MigrationHostedService>(); // chạy migration khi khởi động
builder.Services.AddHostedService<KafkaConsumerService>();

var app = builder.Build();

// No endpoints — background only
app.Run();
