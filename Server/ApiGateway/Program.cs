using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Ocelot.DependencyInjection;
using Ocelot.Middleware;

var builder = WebApplication.CreateBuilder(args);

// Đọc cấu hình Ocelot từ file ocelot.json
builder.Configuration.AddJsonFile("ocelot.json", optional: false, reloadOnChange: true);

// Cấu hình xác thực Firebase JWT
builder.Services.AddAuthentication("Bearer")
    .AddJwtBearer("Bearer", options =>
    {
        var projectId = "sdcrms-49dfb"; // 🔹 Thay bằng Firebase Project ID
        options.Authority = $"https://securetoken.google.com/{projectId}";
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = $"https://securetoken.google.com/{projectId}",
            ValidateAudience = true,
            ValidAudience = projectId,
            ValidateLifetime = true
        };
    }
);
// builder.Services.AddAuthorization(options =>
// {
//     options.AddPolicy("AdminOnly", p => p.RequireClaim("role", "Admin"));
//     options.AddPolicy("OwnerOnly", p => p.RequireClaim("role", "OwnerCar"));
//     options.AddPolicy("StaffOnly", p => p.RequireClaim("role", "Staff"));
//     options.AddPolicy("CustomerOnly", p => p.RequireClaim("role", "Customer"));
// });

// Thêm Ocelot + CORS + Logging
builder.Services.AddOcelot();
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});
builder.Logging.AddConsole();
builder.Logging.AddDebug();

var app = builder.Build();

// Middleware thứ tự quan trọng
app.UseHttpsRedirection();
app.UseCors("AllowAll");          //CORS trước Authentication
app.UseAuthentication();
app.UseAuthorization();

// Kích hoạt Ocelot Gateway
await app.UseOcelot();

app.Run();
