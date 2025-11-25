using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Pomelo.EntityFrameworkCore.MySql;
using Pomelo.EntityFrameworkCore.MySql.Infrastructure;
using SDCRMS;
using SDCRMS.Interfaces;
using SDCRMS.Models;
using SDCRMS.Repositories;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddHttpClient();

// ✅ Đăng ký DbContext
builder.Services.AddDbContext<AppDbContext>(options =>
{
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"));
});

// ✅ Đăng ký repository
builder.Services.AddScoped<IStaffRepository, StaffRepository>();

var app = builder.Build();

// ✅ Thử kết nối SQL Server nhiều lần trước khi khởi chạy API
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();

    int maxRetry = 10;
    int delaySeconds = 5;
    bool connected = false;

    for (int i = 1; i <= maxRetry; i++)
    {
        try
        {
            Console.WriteLine($"⏳ [Attempt {i}/{maxRetry}] Connecting to SQL Server...");
            db.Database.EnsureCreated(); // Tạo DB + bảng nếu chưa có
            Console.WriteLine("✅ Database StaffDB and table Staff created or already exist.");
            connected = true;
            break;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"⚠️ SQL not ready yet: {ex.Message}");
            Thread.Sleep(delaySeconds * 1000);
        }
    }

    if (!connected)
        Console.WriteLine("❌ Failed to connect to SQL Server after multiple attempts!");
}

// Swagger & middlewares
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.MapControllers();
app.Run();
