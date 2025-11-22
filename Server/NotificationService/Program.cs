using System.Security.Claims;
using System.Text;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using SDCRMS.Authorization;
using SDCRMS.Data;
using SDCRMS.Services;

var builder = WebApplication.CreateBuilder(args);

// ========== CORS CONFIGURATION ==========
var allowedOrigins =
    builder.Configuration.GetSection("AllowedOrigins").Get<string[]>() ?? new[]
    {
        "http://localhost:5173",
    };

builder.Services.AddCors(options =>
{
    options.AddPolicy(
        "AllowFrontend",
        policy =>
        {
            policy.WithOrigins(allowedOrigins).AllowAnyMethod().AllowAnyHeader().AllowCredentials();
        }
    );
});

// ========== DATABASE CONFIGURATION ==========
var useInMemory = builder.Configuration.GetValue<bool>("UseInMemoryDatabase");
if (useInMemory)
{
    builder.Services.AddDbContext<NotificationDbContext>(options =>
        options.UseInMemoryDatabase("NotificationServiceDB")
    );
}
else
{
    builder.Services.AddDbContext<NotificationDbContext>(options =>
        options.UseSqlServer(
            builder.Configuration.GetConnectionString("NotificationServiceConnection")
        )
    );
}

// ========== FIREBASE JWT CONFIGURATION ==========
builder
    .Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.Authority = "https://securetoken.google.com/fir-dcrms"; // projectId của bạn
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = "https://securetoken.google.com/fir-dcrms",
            ValidateAudience = true,
            ValidAudience = "fir-dcrms",
            ValidateLifetime = true,
        };
        options.Events = new JwtBearerEvents
        {
            OnTokenValidated = async context =>
            {
                var token =
                    context.SecurityToken as System.IdentityModel.Tokens.Jwt.JwtSecurityToken;
                try
                {
                    var firebaseToken =
                        await FirebaseAdmin.Auth.FirebaseAuth.DefaultInstance.VerifyIdTokenAsync(
                            token.RawData
                        );
                    // Có thể add thêm claim vào context.Principal nếu muốn
                }
                catch
                {
                    context.Fail("Invalid Firebase token");
                }
            },
        };
    });

// Khởi tạo FirebaseApp (chỉ cần chạy 1 lần ở mỗi service)
FirebaseApp.Create(
    new AppOptions() { Credential = GoogleCredential.FromFile("FireBase/FireBaseToken.json") }
);

builder.Services.AddRoleBasedAuthorization();

// ========== DEPENDENCY INJECTION ==========
// Notification Service only needs Notification-related services
builder.Services.AddScoped<FCMService>();
builder.Services.AddScoped<
    SDCRMS.Repositories.INotificationRepository,
    SDCRMS.Repositories.NotificationRepository
>();
builder.Services.AddScoped<INotificationServices, NotificationServices>();

// ========== CONTROLLERS & SWAGGER ==========
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc(
        "v1",
        new OpenApiInfo
        {
            Title = "SDCRMS Notification Service",
            Version = "v1",
            Description = "Microservice for Notification & FCM Management",
        }
    );

    c.AddSecurityDefinition(
        "Bearer",
        new OpenApiSecurityScheme
        {
            Type = SecuritySchemeType.Http,
            Scheme = "bearer",
            BearerFormat = "JWT",
            Description = "Enter JWT token",
        }
    );

    c.AddSecurityRequirement(
        new OpenApiSecurityRequirement
        {
            {
                new OpenApiSecurityScheme
                {
                    Reference = new OpenApiReference
                    {
                        Type = ReferenceType.SecurityScheme,
                        Id = "Bearer",
                    },
                },
                Array.Empty<string>()
            },
        }
    );
});

var app = builder.Build();

// ========== MIDDLEWARE PIPELINE ==========
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "Admin Service v1");
    });
}

app.UseCors("AllowFrontend");
app.UseAuthentication();
app.UseAuthorization();

// Health check endpoint
app.MapGet(
    "/health",
    () => Results.Ok(new { status = "healthy", service = "NotificationService" })
);

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<NotificationDbContext>();
    db.Database.EnsureCreated();
}

app.Run();
