using SDCRMS.Models;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace SDCRMS.Repositories
{
    public interface IMaintenanceRepository
    {
        Task<INumerable<Maintenance>> layTatCaMaintenanceAsync();
        Task<Maintenance?> layMaintenanceTheoIdAsync(int maintenanceId);
        Task<Maintenance> themMaintenanceAsync(Maintenance maintenance);
        Task<Maintenance?> capNhatMaintenanceAsync(Maintenance maintenance);
        Task<bool> xoaMaintenanceAsync(int maintenanceId);
        Task<IEnumerable<Maintenance>> layTatCaMaintenanceTheoCarIdAsync(int carId);
    }
    public class MaintenanceRepository : IMaintenanceRepository
    {
        private readonly AppDbContext _context;

        public MaintenanceRepository(AppDbContext context)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
        }

        public async Task<INumerable<Maintenance>> layTatCaMaintenanceAsync()
        {
            return await _context.Maintenances.Include(m => m.Car).ToListAsync();
        }

        public async Task<Maintenance?> layMaintenanceTheoIdAsync(int maintenanceId)
        {
            return await _context.Maintenances.Include(m => m.Car)
                                              .FirstOrDefaultAsync(m => m.MaintenanceID == maintenanceId);
        }
        public async Task<Maintenance> themMaintenanceAsync(Maintenance maintenance)
        {
            _context.Maintenances.Add(maintenance);
            await _context.SaveChangesAsync();
            return maintenance;
        }
        public async Task<Maintenance?> capNhatMaintenanceAsync(Maintenance maintenance)
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
        public async Task<bool> xoaMaintenanceAsync(int maintenanceId)
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
        public async Task<IEnumerable<Maintenance>> layTatCaMaintenanceTheoCarIdAsync(int carId)
        {
            return await _context.Maintenances
                                 .Where(m => m.CarID == carId)
                                 .Include(m => m.Car)
                                 .ToListAsync();
        }
    }
}