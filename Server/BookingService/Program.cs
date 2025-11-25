using System;
using BookingService.Interfaces;
using BookingService.Models;
using BookingService.Repositories;
using BookingService.Services;
using BookingService.VnPay;
using Microsoft.EntityFrameworkCore;
using Pomelo.EntityFrameworkCore.MySql;
using Pomelo.EntityFrameworkCore.MySql.Infrastructure;
using Redis.Shared.Extensions;

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

// Cấu hình Redis Shared (đăng ký IRedisCacheService, interceptor, v.v.)
builder.Services.AddRedisShared(builder.Configuration);

//Đăng kí Repositores
//builder.Services.AddScoped<IBookingRepository, BookingRepository>();
builder.Services.AddProxiedService<IBookingRepository, BookingRepository>();
builder.Services.AddScoped<IPaymentRepository, PaymentRepository>();
builder.Services.AddScoped<IReviewRepository, ReviewRepository>();

//Đăng ký HttpClient
builder.Services.AddHttpClient<CustomerClient>();
builder.Services.AddScoped<IVnPayService, VnPayService>();

// Đăng kí VNPay

var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.Migrate(); // tạo DB + chạy migrations nếu chưa có
}

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
