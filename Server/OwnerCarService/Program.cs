using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using SDCRMS.Mappers;
using SDCRMS.Repositories;
using SDCRMS.Services;

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

// Đăng ký DbContext với connection string
builder.Services.AddDbContext<AppDbContext>(options =>
{
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"));
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
builder.Services.AddScoped<ICarService, SDCRMS.Services.CarService>();
builder.Services.AddScoped<IOwnerCarService, OwnerCarService>();
builder.Services.AddScoped<IMaintenanceService, MaintenanceService>();

var app = builder.Build();

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
app.UseAuthorization();
app.MapControllers();

app.Run();
