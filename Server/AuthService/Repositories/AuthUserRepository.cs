using AuthService.Models;
using Microsoft.EntityFrameworkCore;
using AuthService.Data;

namespace AuthService.Repositories
{
    public interface IAuthUserRepository
    {
        Task<AuthUser?> GetByFirebaseUidAsync(string firebaseUid);
        Task<AuthUser?> GetByEmailAsync(string email);
        Task<AuthUser> AddAsync(AuthUser user);
        Task UpdateAsync(AuthUser user);
        Task SaveChangesAsync();
        Task<List<AuthUser>> GetAllAsync(); // ✅ Lấy tất cả user trong DB
        Task DeleteAsync(AuthUser user); // ✅ Xóa user
    }

    public class AuthUserRepository : IAuthUserRepository
    {
        private readonly AppDbContext _context;

        public AuthUserRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<AuthUser?> GetByFirebaseUidAsync(string firebaseUid)
        {
            return await _context.AuthUsers
                .FirstOrDefaultAsync(u => u.FirebaseUid == firebaseUid);
        }

        public async Task<AuthUser?> GetByEmailAsync(string email)
        {
            return await _context.AuthUsers
                .FirstOrDefaultAsync(u => u.Email == email);
        }

        public async Task<AuthUser> AddAsync(AuthUser user)
        {
            _context.AuthUsers.Add(user);
            await _context.SaveChangesAsync();
            return user;
        }

        public async Task UpdateAsync(AuthUser user)
        {
            _context.AuthUsers.Update(user);
            await _context.SaveChangesAsync();
        }

        public async Task SaveChangesAsync()
        {
            await _context.SaveChangesAsync();
        }

        public async Task<List<AuthUser>> GetAllAsync()
        {
            return await _context.AuthUsers.ToListAsync();
        }

        public async Task DeleteAsync(AuthUser user)
        {
            _context.AuthUsers.Remove(user);
            await _context.SaveChangesAsync();
        }
    }
}
