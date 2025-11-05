namespace AuthService.Data
{
    using Microsoft.EntityFrameworkCore;
    using AuthService.Models;

    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }

        public DbSet<AuthUser> AuthUsers { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<AuthUser>(entity =>
            {
                entity.HasKey(u => u.Id);
                entity.HasIndex(u => u.FirebaseUid).IsUnique();
                entity.Property(u => u.Email).IsRequired();
                entity.Property(u => u.Role).HasDefaultValue("Customer");
            });
        }
    }
}
