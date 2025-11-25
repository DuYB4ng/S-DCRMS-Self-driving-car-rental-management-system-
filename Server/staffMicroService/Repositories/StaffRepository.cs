using Microsoft.EntityFrameworkCore;
using SDCRMS.Dtos.Staff;
using SDCRMS.Interfaces;
using SDCRMS.Models;

namespace SDCRMS.Repositories
{
    public class StaffRepository : IStaffRepository
    {
        private readonly AppDbContext _context;

        public StaffRepository(AppDbContext context)
        {
            _context = context;
        }

        // Lấy toàn bộ nhân viên
        public async Task<List<Staff>> GetAllAsync()
        {
            return await _context.Staffs.ToListAsync();
        }

        // Lấy theo ID
        public async Task<Staff?> GetByIdAsync(int id)
        {
            return await _context.Staffs
                .AsNoTracking()
                .FirstOrDefaultAsync(s => s.StaffId == id);
        }

        // Tạo nhân viên mới
        public async Task<Staff?> CreateAsync(Staff staffModel)
        {
            try
            {
                await _context.Staffs.AddAsync(staffModel);
                await _context.SaveChangesAsync();
                return staffModel;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[StaffRepository.CreateAsync] ❌ Error: {ex.Message}");
                return null;
            }
        }

        // Cập nhật nhân viên
        public async Task<Staff?> UpdateAsync(int id, UpdateStaffRequestDto staffDto)
        {
            var existingStaff = await _context.Staffs.FindAsync(id);
            if (existingStaff == null)
                return null;
            existingStaff.FirebaseUid = staffDto.FirebaseUid;
            try
            {
                await _context.SaveChangesAsync();
                return existingStaff;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[StaffRepository.UpdateAsync] ❌ Error: {ex.Message}");
                return null;
            }
        }

        // Xóa nhân viên
        public async Task<Staff?> DeleteAsync(int id)
        {
            var existingStaff = await _context.Staffs.FindAsync(id);
            if (existingStaff == null)
                return null;

            try
            {
                _context.Staffs.Remove(existingStaff);
                await _context.SaveChangesAsync();
                return existingStaff;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[StaffRepository.DeleteAsync] ❌ Error: {ex.Message}");
                return null;
            }
        }
    }
}
