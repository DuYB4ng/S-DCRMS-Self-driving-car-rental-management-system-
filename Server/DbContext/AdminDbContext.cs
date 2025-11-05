using Microsoft.EntityFrameworkCore;
using SDCRMS.Models;

namespace SDCRMS.Data
{
    public class AdminDbContext : DbContext
    {
        public AdminDbContext(DbContextOptions<AdminDbContext> options)
            : base(options) { }

        // Chỉ chứa tables liên quan Admin & Notification
        public DbSet<Admin> Admins { get; set; }
        public DbSet<Notification> Notifications { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Config table names
            modelBuilder.Entity<Admin>(entity =>
            {
                entity.ToTable("Admins");
                entity.HasKey(e => e.UserID);
                entity.Property(e => e.Email).IsRequired();
                entity.HasIndex(e => e.Email).IsUnique();
            });

            modelBuilder.Entity<Notification>(entity =>
            {
                entity.ToTable("Notifications");
                entity.HasKey(e => e.NotificationID);
                entity.Property(e => e.Title).IsRequired();
                entity.Property(e => e.Message).IsRequired();
            });
        }
    }
}
