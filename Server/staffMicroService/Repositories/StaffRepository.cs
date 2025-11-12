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

        public async Task<Staff?> CreateAsync(Staff staffModel)
        {
            await _context.Staffs.AddAsync(staffModel);
            await _context.SaveChangesAsync();
            return staffModel;
        }

        public async Task<Staff?> DeleteAsync(int id)
        {
            var staffModel = await _context.Staffs.FirstOrDefaultAsync(x => x.ID == id);
            if (staffModel == null)
            {
                return null;
            }

            _context.Staffs.Remove(staffModel);
            await _context.SaveChangesAsync();
            return staffModel;
        }

        public async Task<List<Staff>> GetAllAsync()
        {
            return await _context.Staffs.ToListAsync();
        }

        public async Task<Staff?> GetByIdAsync(int id)
        {
            return await _context.Staffs.FindAsync(id);
        }

        public async Task<Staff?> UpdateAsync(int id, UpdateStaffRequestDto staffDto)
        {
            var existingStaff = await _context.Staffs.FirstOrDefaultAsync(x => x.ID == id);
            if (existingStaff == null)
            {
                return null;


            }
            existingStaff.FirstName = staffDto.FirstName;
            existingStaff.LastName = staffDto.LastName;
            existingStaff.Email = staffDto.Email;
            existingStaff.PhoneNumber = staffDto.PhoneNumber;
            existingStaff.Address = staffDto.Address;
            await _context.SaveChangesAsync();
            return existingStaff;
        }
    }
}
