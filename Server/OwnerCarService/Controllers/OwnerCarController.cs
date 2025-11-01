using Microsoft.AspNetCore.Mvc;
using SDCRMS.Dtos.Car;
using SDCRMS.Dtos.OwnerCar;
using SDCRMS.Services;

namespace SDCRMS.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class OwnerCarController : ControllerBase
    {
        private readonly IOwnerCarService _ownerCarService;

        public OwnerCarController(IOwnerCarService ownerCarService)
        {
            _ownerCarService = ownerCarService;
        }

        // 🧩 Lấy tất cả chủ xe
        [HttpGet]
        public async Task<IActionResult> GetAllOwnerCars()
        {
            var ownerCars = await _ownerCarService.LayTatCaOwnerCarAsync();
            return Ok(ownerCars);
        }

        // 🔍 Lấy chủ xe theo ID
        [HttpGet("{id:int}")]
        public async Task<IActionResult> GetOwnerCarById(int id)
        {
            var ownerCar = await _ownerCarService.LayOwnerCarTheoIdAsync(id);
            return ownerCar == null ? NotFound() : Ok(ownerCar);
        }

        // ➕ Tạo chủ xe mới
        [HttpPost]
        public async Task<IActionResult> CreateOwnerCar([FromBody] CreateOwnerCarDTO ownerCarDto)
        {
            if (ownerCarDto == null)
                return BadRequest("Dữ liệu không hợp lệ.");

            var createdOwnerCar = await _ownerCarService.ThemOwnerCarAsync(ownerCarDto);
            return CreatedAtAction(nameof(GetOwnerCarById),
                new { id = createdOwnerCar!.OwnerCarId },
                createdOwnerCar);
        }

        // 🚗 Thêm xe cho chủ xe
        [HttpPost("{ownerId:int}/cars")]
        public async Task<IActionResult> AddCarToOwner(int ownerId, [FromBody] CreateCarDTO carDto)
        {
            if (carDto == null)
                return BadRequest("Thông tin xe không hợp lệ.");

            try
            {
                var createdCar = await _ownerCarService.OwnerCarThemCarAsync(ownerId, carDto);
                return CreatedAtAction(nameof(GetCarById),
                    new { carId = createdCar.CarID },
                    createdCar);
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(new { message = ex.Message });
            }
        }

        // 🔍 Lấy xe theo ID
        [HttpGet("cars/{carId:int}")]
        public async Task<IActionResult> GetCarById(int carId)
        {
            var car = await _ownerCarService.LayXeTheoIdAsync(carId);
            return car == null ? NotFound() : Ok(car);
        }

        // ✏️ Cập nhật xe của chủ xe
        [HttpPut("cars/{carId:int}")]
        public async Task<IActionResult> UpdateCarOfOwner(int carId, [FromBody] UpdateCarDTO carDto)
        {
            if (carDto == null || carDto.CarID != carId)
                return BadRequest("Dữ liệu cập nhật không hợp lệ.");

            try
            {
                var updatedCar = await _ownerCarService.OwnerCarCapNhatCarAsync(carId, carDto);
                return Ok(updatedCar);
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(new { message = ex.Message });
            }
        }

        // Xóa xe của chủ xe
        [HttpDelete("cars/{carId:int}")]
        public async Task<IActionResult> DeleteCarOfOwner(int carId)
        {
            try
            {
                var result = await _ownerCarService.XoaCarChoOwnerAsync(carId);
                return result ? NoContent() : StatusCode(500, "Không thể xóa xe.");
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(new { message = ex.Message });
            }
        }

        // 🔄 Đổi trạng thái hoạt động xe (IsActive)
        [HttpPatch("cars/{carId:int}/state")]
        public async Task<IActionResult> ToggleCarState(int carId)
        {
            try
            {
                var newState = await _ownerCarService.DoiStateCarAsync(carId);
                return Ok(new { carId, isActive = newState });
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(new { message = ex.Message });
            }
        }

        // 🛠️ Thêm bảo trì cho xe
        [HttpPost("cars/{carId:int}/maintenances")]
        public async Task<IActionResult> AddMaintenanceToCar(int carId, [FromBody] CreateMaintenanceDTO maintenanceDto)
        {
            if (maintenanceDto == null)
                return BadRequest("Thông tin bảo trì không hợp lệ.");

            try
            {
                var createdMaintenance = await _ownerCarService.ThemMaintenanceChoXeAsync(carId, maintenanceDto);
                return CreatedAtAction(nameof(GetMaintenanceById),
                    new { carId = carId, maintenanceId = createdMaintenance.MaintenanceID },
                    createdMaintenance);
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(new { message = ex.Message });
            }
        }

        // 🔍 Lấy chi tiết bảo trì
        [HttpGet("cars/{carId:int}/maintenances/{maintenanceId:int}")]
        public async Task<IActionResult> GetMaintenanceById(int carId, int maintenanceId)
        {
            var maintenance = await _ownerCarService.LayMaintenanceTheoIdAsync(maintenanceId);
            if (maintenance == null || maintenance.CarID != carId)
                return NotFound();

            return Ok(maintenance);
        }
        [HttpPut("{ownerId:int}")]
        public async Task<IActionResult> UpdateOwnerCar(int ownerId, [FromBody] UpdateOwnerCarDTO ownerCarDto)
        {
            if (ownerCarDto == null)
                return BadRequest("Dữ liệu cập nhật không hợp lệ.");

            var updatedOwnerCar = await _ownerCarService.CapNhatOwnerCarAsync(ownerId, ownerCarDto);
            if (updatedOwnerCar == null)
                return NotFound();

            return Ok(updatedOwnerCar);
        }
        [HttpDelete("{ownerCarId:int}")]
        public async Task<IActionResult> DeleteOwnerCar(int ownerCarId)
        {
            var result = await _ownerCarService.XoaOwnerCarAsync(ownerCarId);
            if (!result)
                return NotFound();

            return NoContent();
        }
    }
}
