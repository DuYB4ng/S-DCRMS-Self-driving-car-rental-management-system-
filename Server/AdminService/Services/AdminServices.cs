using SDCRMS.Models;
using SDCRMS.Repositories;

namespace SDCRMS.Services
{
    public interface IAdminServices
    {
        Task<IEnumerable<Admin>> LayTatCaAdminAsync();
        Task<Admin?> LayAdminTheoIdAsync(int id);
        Task<Admin?> LayAdminTheoEmailAsync(string email);
        Task<Admin> TaoAdminAsync(Admin admin, string plainPassword);
        Task<Admin?> CapNhatAdminAsync(int id, Admin admin, string? newPassword = null);
        Task<Admin?> XoaAdminAsync(int id);
    }

    public class AdminServices : IAdminServices
    {
        private readonly IAdminRepository _adminRepository;
        private readonly IPasswordHasher _passwordHasher;

        public AdminServices(IAdminRepository adminRepository, IPasswordHasher passwordHasher)
        {
            _adminRepository = adminRepository;
            _passwordHasher = passwordHasher;
        }

        public async Task<IEnumerable<Admin>> LayTatCaAdminAsync()
        {
            return await _adminRepository.LayTatCaAdminAsync();
        }

        public async Task<Admin?> LayAdminTheoIdAsync(int id)
        {
            return await _adminRepository.LayAdminTheoIdAsync(id);
        }

        public async Task<Admin?> LayAdminTheoEmailAsync(string email)
        {
            return await _adminRepository.LayAdminTheoEmailAsync(email);
        }

        public async Task<Admin> TaoAdminAsync(Admin admin, string plainPassword)
        {
            // Hash password trước khi lưu
            admin.Password = _passwordHasher.HashPassword(plainPassword);
            return await _adminRepository.TaoAdminAsync(admin);
        }

        public async Task<Admin?> CapNhatAdminAsync(int id, Admin admin, string? newPassword = null)
        {
            // Nếu có password mới, hash nó
            if (!string.IsNullOrEmpty(newPassword))
            {
                admin.Password = _passwordHasher.HashPassword(newPassword);
            }
            return await _adminRepository.CapNhatAdminAsync(id, admin);
        }

        public async Task<Admin?> XoaAdminAsync(int id)
        {
            return await _adminRepository.XoaAdminAsync(id);
        }
    }
}
