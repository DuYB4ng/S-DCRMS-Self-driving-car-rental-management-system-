using AutoMapper;
using OwnerCarService.Dtos.Car;
using OwnerCarService.Models;
using OwnerCarService.Repositories;

namespace OwnerCarService.Services
{
    public interface ICarService
    {
        Task<IEnumerable<CarDTO>> LayTatCaXeAsync();
        Task<CarDTO?> LayXeTheoIdAsync(int carId);
        Task<CarDTO> ThemXeAsync(CreateCarDTO carDto);
        Task<CarDTO?> CapNhatXeAsync(UpdateCarDTO carDto);
        Task<bool> XoaXeAsync(int carId);
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

        public async Task<IEnumerable<CarDTO>> LayTatCaXeAsync()
        {
            var cars = await _carRepository.LayTatCaXeAsync();
            return _mapper.Map<IEnumerable<CarDTO>>(cars);
        }

        public async Task<CarDTO?> LayXeTheoIdAsync(int carId)
        {
            var car = await _carRepository.LayXeTheoIdAsync(carId);
            return car == null ? null : _mapper.Map<CarDTO>(car);
        }

        public async Task<CarDTO> ThemXeAsync(CreateCarDTO carDTO)
        {
            if (string.IsNullOrWhiteSpace(carDTO.NameCar))
                throw new ArgumentException("Tên xe không được để trống.");

            if (carDTO.PricePerDay <= 0)
                throw new ArgumentException("Giá thuê xe phải lớn hơn 0.");

            var car = _mapper.Map<Car>(carDTO);
            var newCar = await _carRepository.ThemXeAsync(car);
            return _mapper.Map<CarDTO>(newCar);
        }


        public async Task<CarDTO?> CapNhatXeAsync(UpdateCarDTO carDto)
        {
            var existingCar = await _carRepository.LayXeTheoIdAsync(carDto.CarID);
            if (existingCar == null)
                return null;

            // Cập nhật chỉ những field từ DTO
            _mapper.Map(carDto, existingCar);

            var updatedCar = await _carRepository.CapNhatXeAsync(existingCar);
            return _mapper.Map<CarDTO>(updatedCar);
        }

        public async Task<bool> XoaXeAsync(int carId)
        {
            return await _carRepository.XoaXeAsync(carId);
        }
    }
}