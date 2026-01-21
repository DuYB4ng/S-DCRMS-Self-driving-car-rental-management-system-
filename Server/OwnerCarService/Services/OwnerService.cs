using OwnerCarService.Models;
using OwnerCarService.Repositories;
using Microsoft.EntityFrameworkCore;
using OwnerCarService.Dtos.Car;
using AutoMapper;
using OwnerCarService.Dtos.OwnerCar;
using Redis.Shared.Attributes;

namespace OwnerCarService.Services
{
    public interface IOwnerCarService
    {
        Task<CarDTO> OwnerCarThemCarAsync(int ownerId, CreateCarDTO carDto);
        Task<CarDTO?> OwnerCarCapNhatCarAsync(int carId, UpdateCarDTO carDto);
        Task<bool> DoiStateCarAsync(int carId);
        Task<bool> XoaCarChoOwnerAsync(int carId);

        [Cache(300)]
        Task<IEnumerable<OwnerCarDTO>> LayTatCaOwnerCarAsync();
        [Cache(300)]
        Task<OwnerCarDTO?> LayOwnerCarTheoIdAsync(int ownerCarId);
        [Cache(300)]
        Task<IEnumerable<CarDTO>> LayTatCaXeCuaOwnerCarIdAsync(int ownerCarId);
        Task<OwnerCarDTO?> LayOwnerCarTheoFirebaseUidAsync(string firebaseUid);

        Task<OwnerCarDTO?> ThemOwnerCarAsync(CreateOwnerCarDTO ownerCarDto);
        [Cache(300)]
        Task<CarDTO?> LayXeTheoIdAsync(int carId);
        [Cache(300)]
        Task<MaintenanceDTO?> LayMaintenanceTheoIdAsync(int maintenanceId);
        Task<MaintenanceDTO> ThemMaintenanceChoXeAsync(int carId, CreateMaintenanceDTO maintenanceDto);
        Task<OwnerCarDTO?> CapNhatOwnerCarAsync(int ownerId, UpdateOwnerCarDTO ownerCarDto);
        Task<bool> XoaOwnerCarAsync(int ownerCarId);
    }

    public class OwnerCarService : IOwnerCarService
    {
        private readonly IOwnerCarRepository _ownerCarRepository;
        private readonly ICarRepository _carRepository;
        private readonly IMaintenanceRepository _maintenanceRepository;
        private readonly IMapper _mapper;

        public OwnerCarService(IOwnerCarRepository ownerCarRepository, ICarRepository carRepository,
                               IMaintenanceRepository maintenanceRepository, IMapper mapper)
        {
            _ownerCarRepository = ownerCarRepository;
            _carRepository = carRepository;
            _maintenanceRepository = maintenanceRepository;
            _mapper = mapper;
        }

        public async Task<IEnumerable<OwnerCarDTO>> LayTatCaOwnerCarAsync()
        {
            var ownerCars = await _ownerCarRepository.LayTatCaOwnerCarAsync();
            return _mapper.Map<IEnumerable<OwnerCarDTO>>(ownerCars);
        }


        public async Task<OwnerCarDTO?> LayOwnerCarTheoIdAsync(int ownerCarId)
        {
            var ownerCar = await _ownerCarRepository.LayOwnerCarTheoIdAsync(ownerCarId);
            return ownerCar == null ? null : _mapper.Map<OwnerCarDTO>(ownerCar);
        }

        public async Task<CarDTO> OwnerCarThemCarAsync(int ownerId, CreateCarDTO carDto)
        {
            var ownerCar = await _ownerCarRepository.LayOwnerCarTheoIdAsync(ownerId)
                        ?? throw new KeyNotFoundException("Không tìm thấy chủ xe với ID đã cho.");

            var car = _mapper.Map<Car>(carDto);
            car.OwnerCarID = ownerId;

            var newCar = await _carRepository.ThemXeAsync(car);
            return _mapper.Map<CarDTO>(newCar);
        }


        public async Task<CarDTO?> OwnerCarCapNhatCarAsync(int carId, UpdateCarDTO carDto)
        {
            var car = await _carRepository.LayXeTheoIdAsync(carId)
                    ?? throw new KeyNotFoundException("Không tìm thấy xe cần cập nhật.");

            _mapper.Map(carDto, car);
            car.UpdatedAt = DateTime.UtcNow;

            var updatedCar = await _carRepository.CapNhatXeAsync(car);
            return _mapper.Map<CarDTO>(updatedCar);
        }

        public async Task<bool> XoaCarChoOwnerAsync(int carId)
        {
            var car = await _carRepository.LayXeTheoIdAsync(carId)
                    ?? throw new KeyNotFoundException("Không tìm thấy xe cần xóa.");

            return await _carRepository.XoaXeAsync(carId);
        }

        public async Task<IEnumerable<CarDTO>> LayTatCaXeCuaOwnerCarIdAsync(int ownerCarId)
        {
            var ownerCar = await _ownerCarRepository.LayOwnerCarTheoIdAsync(ownerCarId)
                        ?? throw new KeyNotFoundException("Không tìm thấy chủ xe với ID đã cho.");

            return ownerCar.Cars.Select(c => _mapper.Map<CarDTO>(c)).ToList();
        }

        public async Task<OwnerCarDTO?> ThemOwnerCarAsync(CreateOwnerCarDTO ownerCarDto)
        {
            var ownerCar = _mapper.Map<OwnerCar>(ownerCarDto);
            var newOwnerCar = await _ownerCarRepository.ThemOwnerCarAsync(ownerCar);
            return _mapper.Map<OwnerCarDTO>(newOwnerCar);
        }
        public async Task<CarDTO?> LayXeTheoIdAsync(int carId)
        {
            var car = await _carRepository.LayXeTheoIdAsync(carId);
            return car == null ? null : _mapper.Map<CarDTO>(car);
        }

        public async Task<MaintenanceDTO?> LayMaintenanceTheoIdAsync(int maintenanceId)
        {
            var maintenance = await _maintenanceRepository.LayMaintenanceTheoIdAsync(maintenanceId);
            return maintenance == null ? null : _mapper.Map<MaintenanceDTO>(maintenance);
        }


        public async Task<MaintenanceDTO> ThemMaintenanceChoXeAsync(int carId, CreateMaintenanceDTO maintenanceDto)
        {
            var car = await _carRepository.LayXeTheoIdAsync(carId)
                    ?? throw new KeyNotFoundException("Không tìm thấy xe với ID đã cho.");

            var maintenance = _mapper.Map<Maintenance>(maintenanceDto);
            maintenance.CarID = carId;

            var newMaintenance = await _maintenanceRepository.ThemMaintenanceAsync(maintenance);
            return _mapper.Map<MaintenanceDTO>(newMaintenance);
        }

        public async Task<bool> DoiStateCarAsync(int carId)
        {
            var car = await _carRepository.LayXeTheoIdAsync(carId)
                    ?? throw new KeyNotFoundException("Không tìm thấy xe với ID đã cho.");

            car.IsActive = !car.IsActive;
            await _carRepository.CapNhatXeAsync(car);
            return car.IsActive;
        }
        public async Task<OwnerCarDTO?> CapNhatOwnerCarAsync(int ownerId, UpdateOwnerCarDTO ownerCarDto)
        {
            // dùng ownerId từ route
            var existingOwnerCar = await _ownerCarRepository.LayOwnerCarTheoIdAsync(ownerId);
            if (existingOwnerCar == null)
                return null;

            _mapper.Map(ownerCarDto, existingOwnerCar);

            var updatedOwnerCar = await _ownerCarRepository.CapNhatOwnerCarAsync(existingOwnerCar);
            return _mapper.Map<OwnerCarDTO>(updatedOwnerCar);
        }
        public async Task<bool> XoaOwnerCarAsync(int ownerCarId)
        {
            var ownerCar = await _ownerCarRepository.LayOwnerCarTheoIdAsync(ownerCarId);
            if (ownerCar == null)
            {
                return false;
            }

            return await _ownerCarRepository.XoaOwnerCarAsync(ownerCarId);
        }
        public async Task<OwnerCarDTO?> LayOwnerCarTheoFirebaseUidAsync(string firebaseUid)
        {
            var ownerCar = await _ownerCarRepository.LayOwnerCarTheoFirebaseUidAsync(firebaseUid);
            return ownerCar == null ? null : _mapper.Map<OwnerCarDTO>(ownerCar);
        }
    }
}