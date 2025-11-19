using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Ocelot.DependencyInjection;
using Ocelot.Middleware;

var builder = WebApplication.CreateBuilder(args);

// Add Ocelot configuration
builder.Configuration.AddJsonFile("ocelot.json", optional: false, reloadOnChange: true);

// CORS Configuration
builder.Services.AddCors(options =>
{
    options.AddPolicy(
        "AllowAll",
        policy =>
        {
            policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
        }
    );
});

// JWT Authentication
var jwtSecret =
    builder.Configuration["JwtSettings:Secret"]
    ?? "your-super-secret-key-that-must-be-at-least-32-characters-long-for-security";
var key = Encoding.UTF8.GetBytes(jwtSecret);

builder
    .Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(
        "Bearer",
        options =>
        {
            options.RequireHttpsMetadata = false;
            options.SaveToken = true;
            options.TokenValidationParameters = new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(key),
                ValidateIssuer = true,
                ValidIssuer = builder.Configuration["JwtSettings:Issuer"] ?? "SDCRMS",
                ValidateAudience = true,
                ValidAudience = builder.Configuration["JwtSettings:Audience"] ?? "SDCRMS-Users",
                ValidateLifetime = true,
                ClockSkew = TimeSpan.Zero,
            };
        }
    );

// Add Ocelot
builder.Services.AddOcelot();

var app = builder.Build();

app.UseCors("AllowAll");

// Use Ocelot middleware
await app.UseOcelot();

app.Run();
