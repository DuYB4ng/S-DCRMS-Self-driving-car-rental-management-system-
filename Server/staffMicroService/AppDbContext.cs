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
    


}