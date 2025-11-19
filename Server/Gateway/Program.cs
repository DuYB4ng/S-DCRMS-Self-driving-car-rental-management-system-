using System.Text;
using FirebaseAdmin;
using Gateway.Middleware;
using Google.Apis.Auth.OAuth2;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Ocelot.DependencyInjection;
using Ocelot.Middleware;

var builder = WebApplication.CreateBuilder(args);

// Initialize Firebase Admin SDK
var firebaseCredentialPath =
    builder.Configuration["Firebase:CredentialPath"]
    ?? "/app/FireBase/fir-dcrms-firebase-adminsdk-fbsvc-4764dba2cc.json";

if (File.Exists(firebaseCredentialPath))
{
    FirebaseApp.Create(
        new AppOptions() { Credential = GoogleCredential.FromFile(firebaseCredentialPath) }
    );
    Console.WriteLine("✅ Firebase Admin SDK initialized");
}
else
{
    Console.WriteLine($"⚠️ Firebase credential file not found: {firebaseCredentialPath}");
}

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

// Use Firebase Auth Middleware (verify tokens)
app.UseFirebaseAuth();

// Use Ocelot middleware
await app.UseOcelot();

app.Run();
