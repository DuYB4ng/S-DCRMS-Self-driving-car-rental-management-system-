using AuthService.Data;
using AuthService.Repositories;
using AuthService.Services;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Microsoft.EntityFrameworkCore;
using Pomelo.EntityFrameworkCore.MySql;
using Pomelo.EntityFrameworkCore.MySql.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

// Chỉ khởi tạo Firebase nếu chưa khởi tạo và file tồn tại
if (File.Exists("firebase-adminsdk.json") && FirebaseApp.DefaultInstance == null)
{
    FirebaseApp.Create(
        new AppOptions { Credential = GoogleCredential.FromFile("firebase-adminsdk.json") }
    );
}

// Đăng ký DbContext
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

// Đăng ký Repository
builder.Services.AddScoped<IAuthUserRepository, AuthUserRepository>();

// Đăng ký FirebaseAuthService 👈 THÊM
builder.Services.AddScoped<FirebaseAuthService>();

builder.Services.AddHttpClient();
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

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
app.UseSwagger();
app.UseSwaggerUI();
app.MapControllers();

app.Run();
