    using Microsoft.EntityFrameworkCore;
    using SDCRMS.Models;
    using System.Collections.Generic;
    using System.Threading.Tasks;

    namespace SDCRMS.Repositories
    {
        public interface ICarRepository
        {
            Task<IEnumerable<Car>> layTatCaXeAsync();
            Task<Car?> layXeTheoIdAsync(int carId);
            Task<Car> themXeAsync(Car car);
            Task<Car?> capNhatXeAsync(Car car);
            Task<bool> xoaXeAsync(int carId);
        }

        public class CarRepository : ICarRepository
        {
            private readonly AppDbContext _context;

            public CarRepository(AppDbContext context)
            {
                _context = context ?? throw new ArgumentNullException(nameof(context));
            }

        public Task<Car?> capNhatXeAsync(Car car)
        {
            var existingCar = _context.Cars.Find(car.CarID);
            if (existingCar != null)
            {
                return null;
            }
            existingCar.NameCar = car.NameCar;
            existingCar.LicensePlate = car.LicensePlate;
            existingCar.ModelYear = car.ModelYear;
            existingCar.State = car.State;
            existingCar.Seat = car.Seat;
            existingCar.TypeCar = car.TypeCar;
            existingCar.Price = car.Price;
            existingCar.urlImage = car.urlImage;
            _context.Cars.Update(existingCar);
            _context.SaveChanges();
            return Task.FromResult(existingCar);
        }

            public async Task<IEnumerable<Car>> layTatCaXeAsync()
            {
                return await _context.Cars.ToListAsync();
            }

            public async Task<Car?> layXeTheoIdAsync(int carId)
            {
                return await _context.Cars.FindAsync(carId).AsTask();
            }

            public async Task<Car> themXeAsync(Car car)
            {
                _context.Cars.Add(car);
                await _context.SaveChangesAsync();
                return car;
            }

            public async Task<bool> xoaXeAsync(int carId)
            {
                var car = await _context.Cars.FindAsync(carId);
                if (car != null)
                {
                    _context.Cars.Remove(car);
                    await _context.SaveChangesAsync();
                    return true;
                }
                return false;
            }
        }
    }