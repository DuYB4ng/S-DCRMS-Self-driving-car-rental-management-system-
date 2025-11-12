using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using reiviewService.Interfaces;
using reiviewService.Repositories;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

// ✅ Swagger cấu hình chuẩn có version
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "Review API",
        Version = "v1",
        Description = "API service for managing Reviews in SDCRMS system"
    });
});

// ✅ Đăng ký DbContext
builder.Services.AddDbContext<AppDbContext>(options =>
{
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"));
});

// ✅ Đăng ký Repository
builder.Services.AddScoped<IReviewRepository, ReviewRepository>();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "Review API v1");
        c.RoutePrefix = "swagger"; // bạn có thể để "" để Swagger hiển thị ở root
    });
}

app.UseHttpsRedirection();
app.MapControllers();
app.Run();
