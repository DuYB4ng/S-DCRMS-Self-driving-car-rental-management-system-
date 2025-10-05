using SDCRMS.Models;
using SDCRMS.Repositories;

namespace SDCRMS.Services
{
    public interface IAdminServices
    {
        Task<IEnumerable<Admin>> LayTatCaAdminAsync();
        Task<Admin?> LayAdminTheoIdAsync(int id);
        Task<Admin?> LayAdminTheoEmailAsync(string email);
        Task<Admin> TaoAdminAsync(Admin admin);
        Task<Admin?> CapNhatAdminAsync(int id, Admin admin);
        Task<Admin?> XoaAdminAsync(int id);
    }

    public class AdminServices : IAdminServices
    {
        private readonly IAdminRepository _adminRepository;

        public AdminServices(IAdminRepository adminRepository)
        {
            _adminRepository = adminRepository;
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

        public async Task<Admin> TaoAdminAsync(Admin admin)
        {
            return await _adminRepository.TaoAdminAsync(admin);
        }

        public async Task<Admin?> CapNhatAdminAsync(int id, Admin admin)
        {
            return await _adminRepository.CapNhatAdminAsync(id, admin);
        }

        public async Task<Admin?> XoaAdminAsync(int id)
        {
            return await _adminRepository.XoaAdminAsync(id);
        }
    }
}
