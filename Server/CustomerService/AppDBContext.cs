using Microsoft.EntityFrameworkCore;
using CustomerService.Models;
using System.Reflection.Metadata;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }
    public DbSet<Customer> Customers { get; set; }
}