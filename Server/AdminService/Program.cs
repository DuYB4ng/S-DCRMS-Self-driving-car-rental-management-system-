using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using SDCRMS.Authorization;
using SDCRMS.Data;
using SDCRMS.Models;
using SDCRMS.Models.Enums;
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
        options.UseSqlServer(builder.Configuration.GetConnectionString("AdminServiceConnection"))
    );
}

// ========== JWT CONFIGURATION ==========
var jwtSettings = builder.Configuration.GetSection("JwtSettings");
var signingKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings["Secret"]!));

builder
    .Services.AddAuthentication(x =>
    {
        x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    })
    .AddJwtBearer(x =>
    {
        x.RequireHttpsMetadata = false;
        x.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = signingKey,
            ValidateIssuer = true,
            ValidIssuer = jwtSettings["Issuer"],
            ValidateAudience = true,
            ValidAudience = jwtSettings["Audience"],
            ValidateLifetime = true,
            ClockSkew = TimeSpan.Zero,
            RoleClaimType = ClaimTypes.Role,
        };
    });

builder.Services.AddRoleBasedAuthorization();

// ========== DEPENDENCY INJECTION ==========
builder.Services.AddScoped<IJwtService, JwtService>();
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

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AdminDbContext>();
    var passwordHasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher>();

    db.Database.EnsureCreated();

    // Seed default admin if database is empty
    if (!db.Admins.Any())
    {
        var defaultAdmin = new Admin
        {
            Email = "admin@sdcrms.com",
            Password = passwordHasher.HashPassword("Admin123@"),
            FirstName = "Admin",
            LastName = "System",
            Role = UserRole.Admin,
            JoinDate = DateTime.UtcNow,
            PhoneNumber = "0123456789",
            Sex = "Other",
            Birthday = new DateTime(1990, 1, 1),
            Address = "SDCRMS HQ",
        };
        db.Admins.Add(defaultAdmin);
        db.SaveChanges();
        Console.WriteLine("✅ Default admin created: admin@sdcrms.com / Admin123@");
    }
}

app.Run();
