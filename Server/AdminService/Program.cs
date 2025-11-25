using System.IO;
using System.Security.Claims;
using System.Text;
using System.Threading;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Pomelo.EntityFrameworkCore.MySql;
using Pomelo.EntityFrameworkCore.MySql.Infrastructure;
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
    builder.Services.AddDbContext<AdminDbContext>(options =>
        options.UseInMemoryDatabase("AdminServiceDB")
    );
}
else
{
    builder.Services.AddDbContext<AdminDbContext>(options =>
        options.UseMySql(
            builder.Configuration.GetConnectionString("AdminServiceConnection"),
            ServerVersion.AutoDetect(
                builder.Configuration.GetConnectionString("AdminServiceConnection")
            )
        )
    );
}

builder.Services.AddRoleBasedAuthorization();

// Đăng ký HttpClient cho DI container
builder.Services.AddHttpClient();

// Khởi tạo FirebaseApp (chỉ cần chạy 1 lần ở mỗi service) - thêm log kiểm tra lỗi runtime
try
{
    var tokenPath = Path.Combine(Directory.GetCurrentDirectory(), "FireBase", "FireBaseToken.json");
    Console.WriteLine($"[Firebase] Đường dẫn file token: {tokenPath}");
    if (!File.Exists(tokenPath))
    {
        Console.WriteLine($"[Firebase] File token KHÔNG TỒN TẠI!");
        throw new FileNotFoundException($"Không tìm thấy file token: {tokenPath}");
    }
    using (var stream = new FileStream(tokenPath, FileMode.Open, FileAccess.Read))
    {
        var credential = GoogleCredential.FromStream(stream);
        FirebaseApp.Create(new AppOptions { Credential = credential });
        Console.WriteLine("[Firebase] Khởi tạo FirebaseApp thành công!");
    }
}
catch (Exception ex)
{
    Console.WriteLine($"[Firebase] LỖI khi khởi tạo FirebaseApp: {ex.Message}\n{ex.StackTrace}");
    throw;
}

// Đăng ký custom authentication scheme Firebase
builder
    .Services.AddAuthentication(options =>
    {
        options.DefaultScheme = SDCRMS.Authorization.FirebaseAuthenticationHandler.SchemeName;
    })
    .AddScheme<
        Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions,
        SDCRMS.Authorization.FirebaseAuthenticationHandler
    >(SDCRMS.Authorization.FirebaseAuthenticationHandler.SchemeName, null);

builder.Services.AddRoleBasedAuthorization();

// ========== DEPENDENCY INJECTION ==========
// Notification Service only needs Notification-related services
builder.Services.AddScoped<IPasswordHasher, PasswordHasher>();
builder.Services.AddScoped<
    SDCRMS.Repositories.IAdminRepository,
    SDCRMS.Repositories.AdminRepository
>();
builder.Services.AddScoped<IAdminServices, AdminServices>();

// ========== CONTROLLERS & SWAGGER ==========
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc(
        "v1",
        new OpenApiInfo
        {
            Title = "SDCRMS Admin Service",
            Version = "v1",
            Description = "Microservice for Admin Management & Authentication",
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

// Tự động migrate database khi khởi động container
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<SDCRMS.Data.AdminDbContext>();
    try
    {
        Console.WriteLine("🗄️ Checking AdminDB state...");
        db.Database.Migrate();
        Console.WriteLine("✅ AdminDB created or already up to date.");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"❌ AdminDB migration failed: {ex.Message}");
    }
}

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
app.MapGet("/health", () => Results.Ok(new { status = "healthy", service = "AdminService" }));

app.MapControllers();

app.Run();
