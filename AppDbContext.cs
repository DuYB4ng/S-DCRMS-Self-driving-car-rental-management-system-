using Microsoft.EntityFrameworkCore;
using SDCRMS.Models;
using System.Reflection.Metadata;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public DbSet<Staff> Staffs { get; set; }
    public DbSet<Customer> Customers { get; set; }
    public DbSet<Booking> Bookings { get; set; }
    public DbSet<Car> Cars { get; set; }
    public DbSet<OwnerCar> OwnerCars { get; set; }
    public DbSet<Payment> Payments { get; set; }
    public DbSet<Review> Reviews { get; set; }
    public DbSet<Admin> Admins { get; set; }
    public DbSet<Notification> Notifications { get; set; }
    public DbSet<Maintenance> Maintenances { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Booking>()
            .HasOne(e => e.Payment)          // Booking có 1 Payment
            .WithOne(e => e.Booking)         // Payment có 1 Booking
            .HasForeignKey<Payment>(e => e.BookingID);  // FK nằm ở bảng Payment
    }
}