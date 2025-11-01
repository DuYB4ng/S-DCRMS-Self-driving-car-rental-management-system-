using Microsoft.EntityFrameworkCore;
using SDCRMS.Models;
using SDCRMS.Repositories;

namespace SDCRMS.Repositories
{
    public interface IOwnerCarRepository
    {
        Task<IEnumerable<OwnerCar>> layTatCaOwnerCarAsync();
        Task<OwnerCar?> layOwnerCarTheoIdAsync(int ownerCarId);
        Task<OwnerCar> themOwnerCarAsync(OwnerCar ownerCar);
        Task<OwnerCar?> capNhatOwnerCarAsync(OwnerCar ownerCar);
        Task<bool> xoaOwnerCarAsync(int ownerCarId);
    }

    public class OwnerCarRepository : IOwnerCarRepository
    {
        private readonly AppDbContext _context;

        public OwnerCarRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<OwnerCar>> layTatCaOwnerCarAsync()
        {
            return await _context.OwnerCars.Include(oc => oc.Cars).ToListAsync();
        }
        public async Task<OwnerCar?> layOwnerCarTheoIdAsync(int ownerCarId)
        {
            return await _context.OwnerCars.Include(oc => oc.Cars)
                                           .FirstOrDefaultAsync(oc => oc.OwnerCarId == ownerCarId);
        }

        public async Task<OwnerCar> themOwnerCarAsync(OwnerCar ownerCar)
        {
            _context.OwnerCars.Add(ownerCar);
            await _context.SaveChangesAsync();
            return ownerCar;
        }

        public async Task<OwnerCar?> capNhatOwnerCarAsync(OwnerCar ownerCar)
        {
            var existingOwnerCar = await _context.OwnerCars.FindAsync(ownerCar.OwnerCarId);
            if (existingOwnerCar == null)
            {
                return null;
            }

            _context.Entry(existingOwnerCar).CurrentValues.SetValues(ownerCar);
            await _context.SaveChangesAsync();
            return existingOwnerCar;
        }

        public async Task<bool> xoaOwnerCarAsync(int ownerCarId)
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