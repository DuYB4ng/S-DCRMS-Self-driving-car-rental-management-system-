using Microsoft.EntityFrameworkCore;
using SDCRMS.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace SDCRMS.Repositories
{
    public interface ICarRepository
    {
        Task<IEnumerable<Car>> LayTatCaXeAsync();
        Task<Car?> LayXeTheoIdAsync(int carId);
        Task<Car> ThemXeAsync(Car car);
        Task<Car?> CapNhatXeAsync(Car car);
        Task<bool> XoaXeAsync(int carId);
    }

    public class CarRepository : ICarRepository
    {
        private readonly AppDbContext _context;

        public CarRepository(AppDbContext context)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
        }

        // Lấy tất cả xe (bao gồm chủ xe và bảo trì)
        public async Task<IEnumerable<Car>> LayTatCaXeAsync()
        {
            return await _context.Cars
                .AsNoTracking()
                .Include(c => c.OwnerCar)
                .Include(c => c.Maintenances)
                .ToListAsync();
        }

        // Lấy 1 xe theo ID (kèm quan hệ)
        public async Task<Car?> LayXeTheoIdAsync(int carId)
        {
            return await _context.Cars
                .Include(c => c.OwnerCar)
                .Include(c => c.Maintenances)
                .FirstOrDefaultAsync(c => c.CarID == carId);
        }

        // Thêm xe mới
        public async Task<Car> ThemXeAsync(Car car)
        {
            _context.Cars.Add(car);
            await _context.SaveChangesAsync();
            return car;
        }

        // Cập nhật xe
        public async Task<Car?> CapNhatXeAsync(Car car)
        {
            var existingCar = await _context.Cars.FindAsync(car.CarID);
            if (existingCar == null)
                return null;

            // Cập nhật toàn bộ thông tin
            existingCar.NameCar = car.NameCar;
            existingCar.LicensePlate = car.LicensePlate;
            existingCar.ModelYear = car.ModelYear;
            existingCar.Seat = car.Seat;
            existingCar.TypeCar = car.TypeCar;
            existingCar.Transmission = car.Transmission;
            existingCar.FuelType = car.FuelType;
            existingCar.FuelConsumption = car.FuelConsumption;
            existingCar.Color = car.Color;

            existingCar.PricePerDay = car.PricePerDay;
            existingCar.Deposit = car.Deposit;
            existingCar.IsActive = car.IsActive;
            existingCar.Status = car.Status;
            existingCar.Location = car.Location;

            existingCar.OwnershipType = car.OwnershipType;
            existingCar.RegistrationDate = car.RegistrationDate;
            existingCar.RegistrationPlace = car.RegistrationPlace;
            existingCar.InsuranceExpiryDate = car.InsuranceExpiryDate;
            existingCar.InspectionExpiryDate = car.InspectionExpiryDate;

            existingCar.Description = car.Description;
            existingCar.imageUrls= car.imageUrls;

            _context.Cars.Update(existingCar);
            await _context.SaveChangesAsync();

            return existingCar;
        }

        // Xóa xe
        public async Task<bool> XoaXeAsync(int carId)
        {
            var car = await _context.Cars.FindAsync(carId);
            if (car == null)
                return false;

            _context.Cars.Remove(car);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
