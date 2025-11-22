using FirebaseAdmin;
using Gateway.Middleware;
using Google.Apis.Auth.OAuth2;
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

// Add Ocelot
builder.Services.AddOcelot();

var app = builder.Build();

app.UseCors("AllowAll");

// Use Firebase Auth Middleware (verify tokens)
app.UseFirebaseAuth();

// Use Ocelot middleware
await app.UseOcelot();

app.Run();
