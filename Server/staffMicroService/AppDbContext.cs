using Microsoft.EntityFrameworkCore;
using SDCRMS.Models;

namespace SDCRMS
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }

        public DbSet<Staff> Staffs { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Staff>().ToTable("Staff");

            modelBuilder.Entity<Staff>()
                .HasKey(s => s.StaffId);

            modelBuilder.Entity<Staff>()
                .HasIndex(s => s.FirebaseUid)
                .IsUnique();

            // ✅ Chỉ ràng buộc FullName thôi
            modelBuilder.Entity<Staff>()
                .Property(s => s.FullName)
                .IsRequired()
                .HasMaxLength(100);

            modelBuilder.Entity<Staff>()
                .Property(s => s.Email)
                .HasMaxLength(100);

            modelBuilder.Entity<Staff>()
                .Property(s => s.Status)
                .HasDefaultValue("Active");

            modelBuilder.Entity<Staff>()
                .Property(s => s.HireDate)
                .HasDefaultValueSql("GETDATE()");
        }
    }
}
