using Microsoft.EntityFrameworkCore;
using paymentServices.Models;


public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public DbSet<Payment> Payments { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);


        modelBuilder.Entity<Payment>(entity =>
        {
            entity.HasKey(p => p.PaymentID);
            entity.Property(p => p.Amount).IsRequired();
        });
    }
}
