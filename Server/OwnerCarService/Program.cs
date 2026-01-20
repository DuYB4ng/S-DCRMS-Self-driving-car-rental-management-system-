using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using OwnerCarService.Mappers;
using OwnerCarService.Repositories;
using OwnerCarService.Services;
using Pomelo.EntityFrameworkCore.MySql;
using Pomelo.EntityFrameworkCore.MySql.Infrastructure;
using Redis.Shared.Extensions;
using OwnerCarService.Data;

var builder = WebApplication.CreateBuilder(args);

// ----------------- Đăng ký dịch vụ -----------------
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc(
        "v1",
        new OpenApiInfo
        {
            Title = "Car Service API",
            Version = "v1",
            Description = "API quản lý xe, chủ xe và bảo trì",
        }
    );
});

// Đăng ký DbContext với connection string MySQL
builder.Services.AddDbContext<AppDbContext>(options =>
{
    var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

    var serverVersion = new MySqlServerVersion(new Version(8, 0, 36)); // ví dụ MySQL 8.0.36

    options.UseMySql(
        connectionString,
        serverVersion,
        mySqlOptions =>
        {
            mySqlOptions.EnableRetryOnFailure(5, TimeSpan.FromSeconds(10), null);
        }
    );
});

// Đăng ký AutoMapper
builder.Services.AddAutoMapper(cfg =>
{
    cfg.AddProfile<CarProfile>();
});

// ----------------- Cấu hình CORS -----------------
builder.Services.AddCors(options =>
{
    options.AddPolicy(
        "AllowFrontend",
        policy =>
        {
            policy
                .WithOrigins("http://localhost:5173")
                .AllowAnyHeader()
                .AllowAnyMethod()
                .AllowCredentials();
        }
    );
});

// Đăng ký Repositories
builder.Services.AddScoped<ICarRepository, CarRepository>();
builder.Services.AddScoped<IOwnerCarRepository, OwnerCarRepository>();
builder.Services.AddScoped<IMaintenanceRepository, MaintenanceRepository>();

// Đăng ký Services
builder.Services.AddScoped<ICarService, CarService>();

// builder.Services.AddScoped<IOwnerCarService, OwnerCarService.Services.OwnerCarService>();
builder.Services.AddScoped<IMaintenanceService, MaintenanceService>();
builder.Services.AddScoped<KafkaProducer>();

// Cấu hình Redis Shared Library
builder.Services.AddRedisShared(builder.Configuration);

// Đăng ký service với proxy tự động AOP
builder.Services.AddProxiedService<IOwnerCarService, OwnerCarService.Services.OwnerCarService>();

var app = builder.Build();
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();

    // Tự động migrate nếu có file migration mới
    try
    {
        Console.WriteLine("🗄️ Checking database state...");
        db.Database.Migrate(); // 👈 Dòng này sẽ tự tạo DB nếu chưa tồn tại
        Console.WriteLine("✅ Database created or already up to date.");
        
        DbInitializer.Initialize(db);
    }
    catch (Exception ex)
    {
        Console.WriteLine($"❌ Database migration failed: {ex.Message}");
    }
}

// ----------------- Cấu hình Pipeline -----------------
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "Car Service API v1");
        c.RoutePrefix = string.Empty; // mở swagger tại root "/"
    });
}

app.UseHttpsRedirection();
app.UseCors("AllowFrontend");
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();
