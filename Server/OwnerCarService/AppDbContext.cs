using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using OwnerCarService.Models;
using Pomelo.EntityFrameworkCore.MySql;
using Pomelo.EntityFrameworkCore.MySql.Infrastructure;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options) { }

    public DbSet<Car> Cars { get; set; }
    public DbSet<OwnerCar> OwnerCars { get; set; }
    public DbSet<Maintenance> Maintenances { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder
            .Entity<Maintenance>()
            .HasOne(e => e.Car)
            .WithMany(e => e.Maintenances)
            .HasForeignKey(e => e.CarID)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder
            .Entity<Car>()
            .HasOne(e => e.OwnerCar)
            .WithMany(e => e.Cars)
            .HasForeignKey(e => e.OwnerCarID)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<Car>(entity =>
        {
            entity.Property(e => e.Deposit).HasPrecision(18, 2);
            entity.Property(e => e.PricePerDay).HasPrecision(18, 2);
        });

        modelBuilder.Entity<Maintenance>(entity =>
        {
            entity.Property(e => e.Cost).HasPrecision(18, 2);
        });
    }
}
