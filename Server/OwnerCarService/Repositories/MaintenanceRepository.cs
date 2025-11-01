using OwnerCarService.Models;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace OwnerCarService.Repositories
{
    public interface IMaintenanceRepository
    {
        Task<IEnumerable<Maintenance>> LayTatCaMaintenanceAsync();
        Task<Maintenance?> LayMaintenanceTheoIdAsync(int maintenanceId);
        Task<Maintenance> ThemMaintenanceAsync(Maintenance maintenance);
        Task<Maintenance?> CapNhatMaintenanceAsync(Maintenance maintenance);
        Task<bool> XoaMaintenanceAsync(int maintenanceId);
        Task<IEnumerable<Maintenance>> LayTatCaMaintenanceTheoCarIdAsync(int carId);
    }
    public class MaintenanceRepository : IMaintenanceRepository
    {
        private readonly AppDbContext _context;

        public MaintenanceRepository(AppDbContext context)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
        }

        public async Task<IEnumerable<Maintenance>> LayTatCaMaintenanceAsync()
        {
            return await _context.Maintenances.Include(m => m.Car).ToListAsync();
        }

        public async Task<Maintenance?> LayMaintenanceTheoIdAsync(int maintenanceId)
        {
            return await _context.Maintenances.Include(m => m.Car)
                                              .FirstOrDefaultAsync(m => m.MaintenanceID == maintenanceId);
        }
        public async Task<Maintenance> ThemMaintenanceAsync(Maintenance maintenance)
        {
            _context.Maintenances.Add(maintenance);
            await _context.SaveChangesAsync();
            return maintenance;
        }
        public async Task<Maintenance?> CapNhatMaintenanceAsync(Maintenance maintenance)
        {
            var existingMaintenance = await _context.Maintenances.FindAsync(maintenance.MaintenanceID);
            if (existingMaintenance == null)
            {
                return null; // Không tìm thấy bảo trì để cập nhật
            }

            existingMaintenance.MaintenanceDate = maintenance.MaintenanceDate;
            existingMaintenance.Description = maintenance.Description;
            existingMaintenance.Cost = maintenance.Cost;
            existingMaintenance.Status = maintenance.Status;
            existingMaintenance.CarID = maintenance.CarID;

            _context.Maintenances.Update(existingMaintenance);
            await _context.SaveChangesAsync();

            return existingMaintenance;
        }
        public async Task<bool> XoaMaintenanceAsync(int maintenanceId)
        {
            var maintenance = await _context.Maintenances.FindAsync(maintenanceId);
            if (maintenance == null)
            {
                return false; // Không tìm thấy bảo trì để xóa
            }

            _context.Maintenances.Remove(maintenance);
            await _context.SaveChangesAsync();
            return true;
        }
        public async Task<IEnumerable<Maintenance>> LayTatCaMaintenanceTheoCarIdAsync(int carId)
        {
            return await _context.Maintenances
                                 .Where(m => m.CarID == carId)
                                 .Include(m => m.Car)
                                 .ToListAsync();
        }
    }
}