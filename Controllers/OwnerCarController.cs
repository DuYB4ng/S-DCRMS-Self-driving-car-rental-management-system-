using Microsoft.AspNetCore.Mvc;
using SDCRMS.Dtos.Car;
using SDCRMS.Services;
namespace SDCRMS.Controllers
{
    [ApiController]
    [Route("api/ownercar")]
    public class OwnerCarController: ControllerBase
    {
        private readonly IOwnerCarService _ownerCarService;
        public OwnerCarController(IOwnerCarService ownerCarService)
        {
            _ownerCarService = ownerCarService;
        }
        [HttpGet]
        public async Task<IActionResult> GetAllOwnerCars()
        {
            var ownerCars = await _ownerCarService.layTatCaOwnerCarAsync();
            return Ok(ownerCars);
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> GetOwnerCarById(int id)
        {
            var ownerCar = await _ownerCarService.layOwnerCarTheoIdAsync(id);
            if (ownerCar == null)
            {
                return NotFound();
            }
            return Ok(ownerCar);
        }
        [HttpPost]
        public async Task<IActionResult> CreateOwnerCar([FromBody] CreateOwnerCarDTO ownerCarDto)
        {
            if (ownerCarDto == null)
            {
                return BadRequest();
            }
            var createdOwnerCar = await _ownerCarService.themOwnerCarAsync(ownerCarDto);
            return CreatedAtAction(nameof(GetOwnerCarById), new { id = createdOwnerCar.OwnerCarID }, createdOwnerCar);
        }
        [HttpPost("{ownerId}/cars")]
        public async Task<IActionResult> AddCarToOwner(int ownerId, [FromBody] CreateCarDTO carDto)
        {
            if (carDto == null)
            {
                return BadRequest();
            }

            try
            {
                var createdCar = await _ownerCarService.themCarchoOwnerCarAsync(ownerId, carDto);
                return CreatedAtAction(nameof(GetOwnerCarById), new { id = createdCar.CarID }, createdCar);
            }
            catch (Exception ex)
            {
                return NotFound(new { message = ex.Message });
            }
        }
        [HttpPut("{carId}/cars")]
        public async Task<IActionResult> UpdateCarOfOwner(int carId, [FromBody] UpdateCarDTO carDto)
        {
            if (carDto == null || carDto.CarID != carId)
            {
                return BadRequest();
            }

            var existingCar = await _ownerCarService.layXeTheoIdAsync(carId);
            if (existingCar == null)
            {
                return NotFound();
            }

            var updatedCar = await _ownerCarService.capNhatCarchoOwnerAsync(carId, carDto);
            if (updatedCar == null)
            {
                return NotFound();
            }

            return Ok(updatedCar);
        }
        [HttpDelete("{carId}/cars")]
        public async Task<IActionResult> DeleteCarOfOwner(int carId)
        {
            var existingCar = await _ownerCarService.layXeTheoIdAsync(carId);
            if (existingCar == null)
            {
                return NotFound();
            }

            try
            {
                var result = await _ownerCarService.xoaCarchoOwnerAsync(carId);
                if (!result)
                {
                    return StatusCode(500, "Không thể xóa xe.");
                }
                return NoContent();
            }
            catch (Exception ex)
            {
                return NotFound(new { message = ex.Message });
            }
        }
    }
}