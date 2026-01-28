using BookingService.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public DbSet<Booking> Bookings { get; set; }
    public DbSet<BookingPayment> Payments { get; set; }
    public DbSet<Review> Reviews { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Booking>()
            .HasMany(e => e.Payments)
            .WithOne(e => e.Booking)
            .HasForeignKey(e => e.BookingID)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<BookingPayment>()
            .HasKey(e => e.PaymentID);

        modelBuilder.Entity<Review>()
            .HasOne(e => e.Booking)
            .WithMany(e => e.Reviews)
            .HasForeignKey(e => e.BookingID)
            .OnDelete(DeleteBehavior.Cascade);
    }
}