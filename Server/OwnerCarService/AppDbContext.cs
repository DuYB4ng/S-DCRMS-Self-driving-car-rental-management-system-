using Microsoft.EntityFrameworkCore;
using OwnerCarService.Models;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }
    public DbSet<Car> Cars { get; set; }
    public DbSet<OwnerCar> OwnerCars { get; set; }
    public DbSet<Maintenance> Maintenances { get; set; }
    public DbSet<CarLocation> CarLocations { get; set; }
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        modelBuilder.Entity<Maintenance>()
            .HasOne(e => e.Car)              // Maintenance có 1 Car
            .WithMany(e => e.Maintenances)   // Car có nhiều Maintenance
            .HasForeignKey(e => e.CarID)     // FK nằm ở bảng Maintenance
            .OnDelete(DeleteBehavior.Cascade); // Xóa cascade
        modelBuilder.Entity<Car>()
            .HasOne(e => e.OwnerCar)         // Car có 1 OwnerCar
            .WithMany(e => e.Cars)           // OwnerCar có nhiều Car
            .HasForeignKey(e => e.OwnerCarID) // FK nằm ở bảng Car
            .OnDelete(DeleteBehavior.Cascade); // Xóa cascade
    }
}