using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Ocelot.DependencyInjection;
using Ocelot.Middleware;

var builder = WebApplication.CreateBuilder(args);

// Load file ocelot.json
builder.Configuration.AddJsonFile("ocelot.json", optional: false, reloadOnChange: true);

// 🔐 Firebase Project ID
var firebaseProjectId = "sdcrms-49dfb";

// Cấu hình Authentication cho Ocelot
builder.Services.AddAuthentication()
    .AddJwtBearer("Bearer", options => // 👈 phải trùng với ocelot.json
    {
        options.Authority = $"https://securetoken.google.com/{firebaseProjectId}";
        options.RequireHttpsMetadata = true;
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = $"https://securetoken.google.com/{firebaseProjectId}",
            ValidateAudience = true,
            ValidAudience = firebaseProjectId,
            ValidateLifetime = true
        };
    });

// Tùy chọn thêm Authorization (role-based)
builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("AdminOnly", p => p.RequireClaim("email", "admin@gmail.com"));
});

// Thêm Ocelot và CORS
builder.Services.AddOcelot();
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
        policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod());
});

var app = builder.Build();

app.UseCors("AllowAll");

// 🚀 Quan trọng: Xác thực trước Ocelot
app.UseAuthentication();
app.UseAuthorization();

await app.UseOcelot();

app.Run();
