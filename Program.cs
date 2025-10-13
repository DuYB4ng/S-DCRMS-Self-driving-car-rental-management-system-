using System;
using Microsoft.EntityFrameworkCore;
using SDCRMS.Mappers;
using SDCRMS.Models;
using SDCRMS.Repositories;
using SDCRMS.Services;
using AutoMapper;
using Microsoft.Extensions.DependencyInjection;
var builder = WebApplication.CreateBuilder(args);

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

app.UseAuthorization();

app.MapControllers();

app.Run();
