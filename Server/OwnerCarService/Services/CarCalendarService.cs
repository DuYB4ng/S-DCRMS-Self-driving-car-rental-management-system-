using OwnerCarService.Models;
using OwnerCarService.Repositories;

namespace OwnerCarService.Services
{
    public interface ICarCalendarService
    {
        Task<IEnumerable<CarCalendar>> GetCalendarAsync(int carId);
        Task<CarCalendar> BlockDateAsync(int carId, DateTime date);
        Task<bool> UnblockDateAsync(int carId, DateTime date);
    }

    public class CarCalendarService : ICarCalendarService
    {
        private readonly ICarCalendarRepository _repo;

        public CarCalendarService(ICarCalendarRepository repo)
        {
            _repo = repo;
        }

        public async Task<IEnumerable<CarCalendar>> GetCalendarAsync(int carId)
        {
            return await _repo.GetCalendarByCarIdAsync(carId);
        }

        public async Task<CarCalendar> BlockDateAsync(int carId, DateTime date)
        {
            // Check if already exists
            var existing = await _repo.GetByDateAsync(carId, date);
            if (existing != null) return existing;

            var entry = new CarCalendar
            {
                CarId = carId,
                Date = date,
                Status = "Busy"
            };
            return await _repo.AddAsync(entry);
        }

        public async Task<bool> UnblockDateAsync(int carId, DateTime date)
        {
            var existing = await _repo.GetByDateAsync(carId, date);
            if (existing == null) return false;

            return await _repo.DeleteAsync(existing.Id);
        }
    }
}
