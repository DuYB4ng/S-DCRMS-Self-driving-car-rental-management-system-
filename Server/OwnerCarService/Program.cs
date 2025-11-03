using Microsoft.EntityFrameworkCore;
using OwnerCarService.Mappers;
using OwnerCarService.Repositories;
using OwnerCarService.Services;
using Microsoft.OpenApi.Models;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;

var builder = WebApplication.CreateBuilder(args);

// ----------------- Đăng ký dịch vụ -----------------
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "Car Service API",
        Version = "v1",
        Description = "API quản lý xe, chủ xe và bảo trì"
    });
});
// ----------------- Cấu hình Firebase JWT -----------------
var firebaseProjectId = "sdcrms-49dfb"; // 🔹 Firebase Project ID của bạn

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.Authority = $"https://securetoken.google.com/{firebaseProjectId}";
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = $"https://securetoken.google.com/{firebaseProjectId}",
            ValidateAudience = true,
            ValidAudience = firebaseProjectId,
            ValidateLifetime = true,
            // RoleClaimType = "role", // 🔹 ánh xạ claim role của Firebase
            // NameClaimType = "user_id"
        };
    });

// ----------------- Cấu hình phân quyền theo Role -----------------
// builder.Services.AddAuthorization(options =>
// {
//     options.AddPolicy("AdminOnly", policy => policy.RequireRole("Admin"));
//     options.AddPolicy("OwnerOnly", policy => policy.RequireRole("OwnerCar"));
//     options.AddPolicy("StaffOnly", policy => policy.RequireRole("Staff"));
//     options.AddPolicy("CustomerOnly", policy => policy.RequireRole("Customer"));
// });

// Đăng ký DbContext với connection string
builder.Services.AddDbContext<AppDbContext>(options =>
{
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection"),
        sqlOptions =>
        {
            sqlOptions.EnableRetryOnFailure(5, TimeSpan.FromSeconds(10), null);
        });
});


// Đăng ký AutoMapper
builder.Services.AddAutoMapper(cfg =>
{
    cfg.AddProfile<CarProfile>();
});

// ----------------- Cấu hình CORS -----------------
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend",
        policy =>
        {
            policy.WithOrigins("http://localhost:5173")
                .AllowAnyHeader()
                .AllowAnyMethod()
                .AllowCredentials();
        });
});

// Đăng ký Repositories
builder.Services.AddScoped<ICarRepository, CarRepository>();
builder.Services.AddScoped<IOwnerCarRepository, OwnerCarRepository>();
builder.Services.AddScoped<IMaintenanceRepository, MaintenanceRepository>();

// Đăng ký Services
builder.Services.AddScoped<ICarService, CarService>();
builder.Services.AddScoped<IOwnerCarService, OwnerCarService.Services.OwnerCarService>();
builder.Services.AddScoped<IMaintenanceService, MaintenanceService>();
builder.Services.AddScoped<KafkaProducer>();
// builder.Services.AddHostedService<KafkaConsumerService>();

var app = builder.Build();
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.EnsureCreated();
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
