using Microsoft.EntityFrameworkCore;
using OwnerCarConsumer.Models;

namespace OwnerCarConsumer
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<CarLocation> CarLocations { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            // Nếu bạn chỉ muốn CarLocation thôi, bỏ qua các entity khác
        }
    }
}
