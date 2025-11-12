using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using paymentServices.Interfaces;
using paymentServices.Repositories;
using Microsoft.OpenApi.Models; 
using Swashbuckle.AspNetCore.SwaggerGen;
using Swashbuckle.AspNetCore.SwaggerUI;
using Swashbuckle.AspNetCore.Swagger; // Add this for Swagger middleware

using Microsoft.EntityFrameworkCore.SqlServer;
using paymentServices.Interfaces;
using paymentServices.Repositories;
var builder = WebApplication.CreateBuilder(args);

//Jwt Authentication

// Add services to the container.

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Đăng ký DbContext với connection string
builder.Services.AddDbContext<AppDbContext>(options =>
{
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"));
});
//Đăng kí Repositores 
builder.Services.AddScoped<IPaymentRepository, PaymentRepository>();

var app = builder.Build();

// Add this using directive

// ... rest of your code ...

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
  

    app.UseSwaggerUI(); 
}

app.UseHttpsRedirection();


app.MapControllers();

app.Run();