using Microsoft.EntityFrameworkCore;
using SDCRMS.Models;
using SDCRMS.Repositories;

namespace SDCRMS.Repositories
{
    public interface IOwnerCarRepository
    {
        Task<IEnumerable<OwnerCar>> LayTatCaOwnerCarAsync();
        Task<OwnerCar?> LayOwnerCarTheoIdAsync(int ownerCarId);
        Task<OwnerCar?> ThemOwnerCarAsync(OwnerCar ownerCar);
        Task<OwnerCar?> CapNhatOwnerCarAsync(OwnerCar ownerCar);
        Task<bool> XoaOwnerCarAsync(int ownerCarId);
    }

    public class OwnerCarRepository : IOwnerCarRepository
    {
        private readonly AppDbContext _context;

        public OwnerCarRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<OwnerCar>> LayTatCaOwnerCarAsync()
        {
            return await _context.OwnerCars.Include(oc => oc.Cars).ToListAsync();
        }
        public async Task<OwnerCar?> LayOwnerCarTheoIdAsync(int ownerCarId)
        {
            return await _context.OwnerCars.Include(oc => oc.Cars)
                                           .FirstOrDefaultAsync(oc => oc.OwnerCarId == ownerCarId);
        }

        public async Task<OwnerCar?> ThemOwnerCarAsync(OwnerCar ownerCar)
        {
            if (await _context.OwnerCars.AnyAsync(o => o.UserId == ownerCar.UserId))
                throw new InvalidOperationException("Người dùng này đã có hồ sơ chủ xe.");

            _context.OwnerCars.Add(ownerCar);
            await _context.SaveChangesAsync();
            return ownerCar;
        }

        public async Task<OwnerCar?> CapNhatOwnerCarAsync(OwnerCar ownerCar)
        {
            var existingOwnerCar = await _context.OwnerCars.FindAsync(ownerCar.OwnerCarId);
            if (existingOwnerCar == null)
                return null;

            _context.Entry(existingOwnerCar).CurrentValues.SetValues(ownerCar);
            existingOwnerCar.UpdatedAt = DateTime.UtcNow; 
            await _context.SaveChangesAsync();

            return existingOwnerCar;
        }

        public async Task<bool> XoaOwnerCarAsync(int ownerCarId)
        {
            var ownerCar = await _context.OwnerCars.FindAsync(ownerCarId);
            if (ownerCar == null)
            {
                return false;
            }

            _context.OwnerCars.Remove(ownerCar);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}