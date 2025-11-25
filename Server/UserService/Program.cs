using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using Pomelo.EntityFrameworkCore.MySql;
using Pomelo.EntityFrameworkCore.MySql.Infrastructure;
using UserService.Data;
using UserService.Models;
using UserService.Repositories;
using UserService.Services;

var builder = WebApplication.CreateBuilder(args);

// ----------------- Đăng ký dịch vụ -----------------
builder.Services.AddControllers();

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
// builder.Services.AddAutoMapper(cfg =>
// {
//     cfg.AddProfile<CarProfile>();
// });

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

// Repositories
builder.Services.AddScoped<IUserRepository, UserRepository>();

// Services
builder.Services.AddScoped<IUserService, UserService.Services.UserService>();

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
    }
    catch (Exception ex)
    {
        Console.WriteLine($"❌ Database migration failed: {ex.Message}");
    }
}

app.UseHttpsRedirection();
app.UseCors("AllowFrontend");
app.MapControllers();

app.Run();
