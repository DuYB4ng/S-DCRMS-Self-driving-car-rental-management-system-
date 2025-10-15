
using Microsoft.EntityFrameworkCore;
using SDCRMS.Mappers;
using SDCRMS.Models;
using SDCRMS.Repositories;
using SDCRMS.Services;
using SDCRMS.Interfaces;
using AutoMapper;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
var builder = WebApplication.CreateBuilder(args);

//Jwt Authentication
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true, // Xác thực nhà phát hành
            ValidateAudience = true, // Xác thực người nhận
            ValidateLifetime = true, // Xác thực thời gian sống của token
            ValidateIssuerSigningKey = true, // Xác thực khóa ký
            ValidIssuer = builder.Configuration["Jwt:Issuer"], 
            ValidAudience = builder.Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]))
        };
    });
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
builder.Services.AddScoped<ICarRepository, CarRepository>();
builder.Services.AddScoped<ICustomerRepository, CustomerRepository>();
builder.Services.AddScoped<IBookingRepository, BookingRepository>();
builder.Services.AddScoped<IOwnerCarRepository, OwnerCarRepository>();
builder.Services.AddScoped<IMaintenanceRepository, MaintenanceRepository>();
//Đăng kí Services
builder.Services.AddScoped<ICarService, CarService>();
builder.Services.AddScoped<IOwnerCarService, OwnerCarService>();
builder.Services.AddScoped<IMaintenanceService, MaintenanceService>();
//Đăng kí AutoMapper
builder.Services.AddAutoMapper(cfg =>
{
    cfg.AddProfile<CarProfile>();
});
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();

app.Run();