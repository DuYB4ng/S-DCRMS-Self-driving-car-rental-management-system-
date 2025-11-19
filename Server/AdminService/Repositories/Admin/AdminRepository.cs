using Microsoft.EntityFrameworkCore;
using SDCRMS.Data;
using SDCRMS.Models;
using SDCRMS.Models.Enums;

namespace SDCRMS.Repositories
{
    public interface IAdminRepository
    {
        Task<IEnumerable<Admin>> LayTatCaAdminAsync();
        Task<Admin?> LayAdminTheoIdAsync(int id);
        Task<Admin?> LayAdminTheoEmailAsync(string email);
        Task<Admin> TaoAdminAsync(Admin admin);
        Task<Admin?> CapNhatAdminAsync(int id, Admin admin);
        Task<Admin?> XoaAdminAsync(int id);
    }

    public class AdminRepository : IAdminRepository
    {
        private readonly AdminDbContext _context;

        public AdminRepository(AdminDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Admin>> LayTatCaAdminAsync()
        {
            return await _context.Admins.ToListAsync();
        }

        public async Task<Admin?> LayAdminTheoIdAsync(int id)
        {
            return await _context.Admins.FindAsync(id);
        }

        public async Task<Admin?> LayAdminTheoEmailAsync(string email)
        {
            return await _context.Admins.FirstOrDefaultAsync(a => a.Email == email);
        }

        public async Task<Admin> TaoAdminAsync(Admin admin)
        {
            admin.JoinDate = DateTime.UtcNow;
            admin.Role = UserRole.Admin;
            _context.Admins.Add(admin);
            await _context.SaveChangesAsync();
            return admin;
        }

        public async Task<Admin?> CapNhatAdminAsync(int id, Admin admin)
        {
            var existingAdmin = await _context.Admins.FindAsync(id);
            if (existingAdmin == null)
                return null;

            existingAdmin.LastName = admin.LastName;
            existingAdmin.FirstName = admin.FirstName;
            existingAdmin.Email = admin.Email;
            existingAdmin.PhoneNumber = admin.PhoneNumber;
            existingAdmin.Sex = admin.Sex;
            existingAdmin.Birthday = admin.Birthday;
            existingAdmin.Address = admin.Address;

            await _context.SaveChangesAsync();
            return existingAdmin;
        }

        public async Task<Admin?> XoaAdminAsync(int id)
        {
            var admin = await _context.Admins.FindAsync(id);
            if (admin == null)
                return null;

            _context.Admins.Remove(admin);
            await _context.SaveChangesAsync();
            return admin;
        }
    }
}
