using Microsoft.AspNetCore.Mvc;
using SDCRMS.Dtos.Car;
using SDCRMS.Services;

namespace SDCRMS.Controllers
{
    [ApiController]
    [Route("api/maintenance")]
    public class MaintenanceController: ControllerBase
    {
        private readonly IMaintenanceService _maintenanceService;
        public MaintenanceController(IMaintenanceService maintenanceService)
        {
            _maintenanceService = maintenanceService;
        }
        [HttpGet]
        public async Task<IActionResult> GetAllMaintenances()
        {
            var maintenances = await _maintenanceService.layTatCaMaintenanceAsync();
            return Ok(maintenances);
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> GetMaintenanceById(int id)
        {
            var maintenance = await _maintenanceService.layMaintenanceTheoIdAsync(id);
            if (maintenance == null)
            {
                return NotFound();
            }
            return Ok(maintenance);
        }
        [HttpPost]
        public async Task<IActionResult> CreateMaintenance([FromBody] CreateMaintenanceDTO maintenanceDto)
        {
            if (maintenanceDto == null)
            {
                return BadRequest();
            }
            var createdMaintenance = await _maintenanceService.themMaintenanceAsync(maintenanceDto);
            return CreatedAtAction(nameof(GetMaintenanceById), new { id = createdMaintenance.MaintenanceID }, createdMaintenance);
        }
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateMaintenance(int id, [FromBody] UpdateMaintenanceDTO maintenanceDto)
        {
            if (maintenanceDto == null || id != maintenanceDto.CarID)
            {
                return BadRequest();
            }
            var updatedMaintenance = await _maintenanceService.capNhatMaintenanceAsync(id, maintenanceDto);
            if (updatedMaintenance == null)
            {
                return NotFound();
            }
            return Ok(updatedMaintenance);
        }
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteMaintenance(int id)
        {
            var deleted = await _maintenanceService.xoaMaintenanceAsync(id);
            if (!deleted)
            {
                return NotFound();
            }
            return NoContent();
        }
    }
}