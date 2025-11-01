using SDCRMS.Models;
using SDCRMS.Repositories;
using AutoMapper;
using SDCRMS.Dtos.Car;
namespace SDCRMS.Services
{
    public interface IMaintenanceService
    {
        Task<IEnumerable<MaintenanceDTO>> layTatCaMaintenanceAsync();
        Task<MaintenanceDTO?> layMaintenanceTheoIdAsync(int maintenanceId);
        Task<MaintenanceDTO> themMaintenanceAsync(CreateMaintenanceDTO maintenanceDto);
        Task<MaintenanceDTO?> capNhatMaintenanceAsync(int maintenanceId, UpdateMaintenanceDTO maintenanceDto);
        Task<bool> xoaMaintenanceAsync(int maintenanceId);
        Task<IEnumerable<MaintenanceDTO>> layTatCaMaintenanceTheoCarIdAsync(int carId);
    }
    public class MaintenanceService : IMaintenanceService
    {
        private readonly IMaintenanceRepository _maintenanceRepository;
        private readonly ICarRepository _carRepository;
        private readonly IMapper _mapper;

        public MaintenanceService(IMaintenanceRepository maintenanceRepository, ICarRepository carRepository, IMapper mapper)
        {
            _maintenanceRepository = maintenanceRepository;
            _carRepository = carRepository;
            _mapper = mapper;
        }

        public async Task<IEnumerable<MaintenanceDTO>> layTatCaMaintenanceAsync()
        {
            var maintenances = await _maintenanceRepository.LayTatCaMaintenanceAsync();
            return _mapper.Map<IEnumerable<MaintenanceDTO>>(maintenances);
        }

        public async Task<MaintenanceDTO?> layMaintenanceTheoIdAsync(int maintenanceId)
        {
            var maintenance = await _maintenanceRepository.LayMaintenanceTheoIdAsync(maintenanceId);
            return maintenance == null ? null : _mapper.Map<MaintenanceDTO>(maintenance);
        }

        public async Task<MaintenanceDTO> themMaintenanceAsync(CreateMaintenanceDTO maintenanceDto)
        {
            var car = await _carRepository.LayXeTheoIdAsync(maintenanceDto.CarID);
            if (car == null)
            {
                throw new Exception("Không tìm thấy xe với ID đã cho.");
            }

            var maintenance = _mapper.Map<Maintenance>(maintenanceDto);
            var newMaintenance = await _maintenanceRepository.ThemMaintenanceAsync(maintenance);
            return _mapper.Map<MaintenanceDTO>(newMaintenance);
        }

        public async Task<MaintenanceDTO?> capNhatMaintenanceAsync(int maintenanceId, UpdateMaintenanceDTO maintenanceDto)
        {
            var existingMaintenance = await _maintenanceRepository.LayMaintenanceTheoIdAsync(maintenanceId);
            if (existingMaintenance == null)
            {
                return null; // Không tìm thấy bảo trì để cập nhật
            }

            _mapper.Map(maintenanceDto, existingMaintenance);
            var updatedMaintenance = await _maintenanceRepository.CapNhatMaintenanceAsync(existingMaintenance);
            return updatedMaintenance == null ? null : _mapper.Map<MaintenanceDTO>(updatedMaintenance);
        }

        public async Task<bool> xoaMaintenanceAsync(int maintenanceId)
        {
            return await _maintenanceRepository.XoaMaintenanceAsync(maintenanceId);
        }

        public async Task<IEnumerable<MaintenanceDTO>> layTatCaMaintenanceTheoCarIdAsync(int carId)
        {
            var maintenances = await _maintenanceRepository.LayTatCaMaintenanceTheoCarIdAsync(carId);
            return _mapper.Map<IEnumerable<MaintenanceDTO>>(maintenances);
        }
    }
}