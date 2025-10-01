using SDCRMS.Models;
using SDCRMS.Repositories;

namespace SDCRMS.Services
{
    public interface ICarService
    {
        Task<IEnumerable<Car>> layTatCaXeAsync();
        Task<Car?> layXeTheoIdAsync(int carId);
        Task<Car> themXeAsync(Car car);
        Task<Car?> capNhatXeAsync(Car car);
        Task<bool> xoaXeAsync(int carId);
    }

    public class CarService : ICarService
    {
        private readonly ICarRepository _carRepository;

        public CarService(ICarRepository carRepository)
        {
            _carRepository = carRepository;
        }

        public async Task<IEnumerable<Car>> layTatCaXeAsync()
        {
            return await _carRepository.layTatCaXeAsync();
        }

        public async Task<Car?> layXeTheoIdAsync(int carId)
        {
            return await _carRepository.layXeTheoIdAsync(carId);
        }

        public async Task<Car> themXeAsync(Car car)
        {
            return await _carRepository.themXeAsync(car);
        }

        public async Task<Car?> capNhatXeAsync(Car car)
        {
            return await _carRepository.capNhatXeAsync(car);
        }

        public async Task<bool> xoaXeAsync(int carId)
        {
            return await _carRepository.xoaXeAsync(carId);
        }
    }
}