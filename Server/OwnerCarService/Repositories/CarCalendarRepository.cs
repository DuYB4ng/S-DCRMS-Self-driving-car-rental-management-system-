using Microsoft.EntityFrameworkCore;
using OwnerCarService.Models;

namespace OwnerCarService.Repositories
{
    public interface ICarCalendarRepository
    {
        Task<IEnumerable<CarCalendar>> GetCalendarByCarIdAsync(int carId);
        Task<CarCalendar> AddAsync(CarCalendar entry);
        Task<bool> DeleteAsync(int id);
        Task<CarCalendar> GetByDateAsync(int carId, DateTime date);
    }

    public class CarCalendarRepository : ICarCalendarRepository
    {
        private readonly AppDbContext _context;

        public CarCalendarRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<CarCalendar>> GetCalendarByCarIdAsync(int carId)
        {
            return await _context.CarCalendars
                .Where(c => c.CarId == carId)
                .OrderBy(c => c.Date)
                .ToListAsync();
        }

        public async Task<CarCalendar> AddAsync(CarCalendar entry)
        {
            _context.CarCalendars.Add(entry);
            await _context.SaveChangesAsync();
            return entry;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var entry = await _context.CarCalendars.FindAsync(id);
            if (entry == null) return false;

            _context.CarCalendars.Remove(entry);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<CarCalendar> GetByDateAsync(int carId, DateTime date)
        {
            return await _context.CarCalendars
                .FirstOrDefaultAsync(c => c.CarId == carId && c.Date.Date == date.Date);
        }
    }
}
