using Microsoft.EntityFrameworkCore;
using SDCRMS.Models;

namespace SDCRMS.Data
{
    public class NotificationDbContext : DbContext
    {
        public NotificationDbContext(DbContextOptions<NotificationDbContext> options)
            : base(options) { }

        // Notification Service - quản lý Notifications và FCM Tokens
        public DbSet<Notification> Notifications { get; set; }
        public DbSet<FCMToken> FCMTokens { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Notification>(entity =>
            {
                entity.ToTable("Notifications");
                entity.HasKey(e => e.NotificationID);
                entity.Property(e => e.Title).IsRequired();
                entity.Property(e => e.Message).IsRequired();
            });

            modelBuilder.Entity<FCMToken>(entity =>
            {
                entity.ToTable("FCMTokens");
                entity.HasKey(e => e.TokenID);
                entity.Property(e => e.Token).IsRequired().HasMaxLength(500);
                entity.Property(e => e.DeviceType).IsRequired().HasMaxLength(50);
                entity.HasIndex(e => new { e.UserID, e.Token }).IsUnique();
            });
        }
    }
}
