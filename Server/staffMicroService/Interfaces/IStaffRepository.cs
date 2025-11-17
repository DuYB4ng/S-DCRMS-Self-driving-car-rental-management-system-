using SDCRMS.Dtos.Staff;
using SDCRMS.Models;

namespace SDCRMS.Interfaces
{
    public interface IStaffRepository
    {
        Task<List<Staff>> GetAllAsync();
    Task<Staff?> GetByIdAsync(int id);
        Task<Staff?> CreateAsync(Staff staffModel);
        Task<Staff?> UpdateAsync(int id, UpdateStaffRequestDto staffDto);

        Task<Staff?> DeleteAsync(int id);
    }
}
