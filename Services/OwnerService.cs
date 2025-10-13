using SDCRMS.Models;
using SDCRMS.Repositories;
using Microsoft.EntityFrameworkCore;
using SDCRMS.Dtos.Car;
using AutoMapper;

public interface IOwnerCarService
{
    Task<CarDTO> themCarchoOwnerCarAsync(int ownerId, CreateCarDTO carDto);
    Task<CarDTO?> capNhatCarchoOwnerAsync(int carId, UpdateCarDTO carDto);
    Task<bool> xoaCarchoOwnerAsync(int carId);
    Task<IEnumerable<OwnerCarDTO>> layTatCaOwnerCarAsync();
    Task<OwnerCarDTO?> layOwnerCarTheoIdAsync(int ownerCarId);
    Task<IEnumerable<CarDTO>> layTatCaXeTheoOwnerCarIdAsync(int ownerCarId);
    Task<OwnerCarDTO?> themOwnerCarAsync(CreateOwnerCarDTO ownerCarDto);
    Task<CarDTO?> layXeTheoIdAsync(int carId);
}

public class OwnerCarService : IOwnerCarService
{
    private readonly IOwnerCarRepository _ownerCarRepository;
    private readonly ICarRepository _carRepository;
    private readonly IMapper _mapper;

    public OwnerCarService(IOwnerCarRepository ownerCarRepository, ICarRepository carRepository, IMapper mapper)
    {
        _ownerCarRepository = ownerCarRepository;
        _carRepository = carRepository;
        _mapper = mapper;
    }

    // Lấy toàn bộ chủ xe
    public async Task<IEnumerable<OwnerCarDTO>> layTatCaOwnerCarAsync()
    {
        var ownerCars = await _ownerCarRepository.layTatCaOwnerCarAsync();
        return _mapper.Map<IEnumerable<OwnerCarDTO>>(ownerCars);
    }

    // Lấy 1 chủ xe theo ID
    public async Task<OwnerCarDTO?> layOwnerCarTheoIdAsync(int ownerCarId)
    {
        var ownerCar = await _ownerCarRepository.layOwnerCarTheoIdAsync(ownerCarId);
        return ownerCar == null ? null : _mapper.Map<OwnerCarDTO>(ownerCar);
    }

    // Thêm xe cho chủ xe
    public async Task<CarDTO> themCarchoOwnerCarAsync(int ownerId, CreateCarDTO carDto)
    {
        var ownerCar = await _ownerCarRepository.layOwnerCarTheoIdAsync(ownerId);
        if (ownerCar == null)
        {
            throw new Exception("Không tìm thấy chủ xe với ID đã cho.");
        }

        var car = _mapper.Map<Car>(carDto);
        car.OwnerCarID = ownerId;

        var newCar = await _carRepository.themXeAsync(car);
        return _mapper.Map<CarDTO>(newCar);
    }

    // Cập nhật xe của chủ xe
    public async Task<CarDTO?> capNhatCarchoOwnerAsync(int carId, UpdateCarDTO carDto)
    {
        var car = await _carRepository.layXeTheoIdAsync(carId);
        if (car == null)
        {
            throw new Exception("Không tìm thấy xe cần cập nhật.");
        }

        _mapper.Map(carDto, car); // update các field từ DTO
        var updatedCar = await _carRepository.capNhatXeAsync(car);
        return _mapper.Map<CarDTO>(updatedCar);
    }

    // Xóa xe
    public async Task<bool> xoaCarchoOwnerAsync(int carId)
    {
        var car = await _carRepository.layXeTheoIdAsync(carId);
        if (car == null)
        {
            throw new Exception("Không tìm thấy xe cần xóa.");
        }

        return await _carRepository.xoaXeAsync(carId);
    }

    // Lấy tất cả xe của 1 chủ xe
    public async Task<IEnumerable<CarDTO>> layTatCaXeTheoOwnerCarIdAsync(int ownerCarId)
    {
        var ownerCar = await _ownerCarRepository.layOwnerCarTheoIdAsync(ownerCarId);
        if (ownerCar == null)
        {
            throw new Exception("Không tìm thấy chủ xe với ID đã cho.");
        }

        return ownerCar.Cars.Select(c => _mapper.Map<CarDTO>(c)).ToList();
    }
    // Thêm chủ xe
    public async Task<OwnerCarDTO?> themOwnerCarAsync(CreateOwnerCarDTO ownerCarDto)
    {
        var ownerCar = _mapper.Map<OwnerCar>(ownerCarDto);
        var newOwnerCar = await _ownerCarRepository.themOwnerCarAsync(ownerCar);
        return _mapper.Map<OwnerCarDTO>(newOwnerCar);
    }
    // Lấy xe theo ID
    public async Task<CarDTO?> layXeTheoIdAsync(int carId)
    {
        var car = await _carRepository.layXeTheoIdAsync(carId);
        return car == null ? null : _mapper.Map<CarDTO>(car);
    }
}
