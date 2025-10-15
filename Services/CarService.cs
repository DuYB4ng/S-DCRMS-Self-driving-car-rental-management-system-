using AutoMapper;
using SDCRMS.Dtos.Car;
using SDCRMS.Models;
using SDCRMS.Repositories;

namespace SDCRMS.Services
{
    public interface ICarService
    {
        Task<IEnumerable<CarDTO>> layTatCaXeAsync();
        Task<CarDTO?> layXeTheoIdAsync(int carId);
        Task<CarDTO> themXeAsync(CreateCarDTO carDto);
        Task<CarDTO?> capNhatXeAsync(UpdateCarDTO carDto);
        Task<bool> xoaXeAsync(int carId);
    }

    public class CarService : ICarService
    {
        private readonly ICarRepository _carRepository;
        private readonly IMapper _mapper;

        public CarService(ICarRepository carRepository, IMapper mapper)
        {
            _carRepository = carRepository;
            _mapper = mapper;
        }

        public async Task<IEnumerable<CarDTO>> layTatCaXeAsync()
        {
            var cars = await _carRepository.layTatCaXeAsync();
            return _mapper.Map<IEnumerable<CarDTO>>(cars);
        }

        public async Task<CarDTO?> layXeTheoIdAsync(int carId)
        {
            var car = await _carRepository.layXeTheoIdAsync(carId);
            return car == null ? null : _mapper.Map<CarDTO>(car);
        }

        public async Task<CarDTO> themXeAsync(CreateCarDTO carDTO)
        {
            var car = _mapper.Map<Car>(carDTO);
            var newCar = await _carRepository.themXeAsync(car);
            return _mapper.Map<CarDTO>(newCar);
        }

        public async Task<CarDTO?> capNhatXeAsync(UpdateCarDTO carDto)
        {
            var car = _mapper.Map<Car>(carDto);
            var updatedCar = await _carRepository.capNhatXeAsync(car);
            return updatedCar == null ? null : _mapper.Map<CarDTO>(updatedCar);
        }

        public async Task<bool> xoaXeAsync(int carId)
        {
            return await _carRepository.xoaXeAsync(carId);
        }
    }
}