using Microsoft.AspNetCore.Mvc;
using SDCRMS.Dtos.Car;
using SDCRMS.Models;
using SDCRMS.Services;
namespace SDCRMS.Controllers
{
    [ApiController]
    [Route("api/car")]
    public class CarController : ControllerBase
    {   
        private readonly ICarService _carService;

        public CarController(ICarService carService)
        {
            _carService = carService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllCars()
        {
            var cars = await _carService.layTatCaXeAsync();
            return Ok(cars);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetCarById(int id)
        {
            var car = await _carService.layXeTheoIdAsync(id);
            if (car == null)
            {
                return NotFound();
            }
            return Ok(car);
        }

        [HttpPost]
        public async Task<IActionResult> CreateCar([FromBody] CreateCarDTO carDto)
        {
            if (carDto == null)
            {
                return BadRequest();
            }
            var createdCar = await _carService.themXeAsync(carDto);
            return CreatedAtAction(nameof(GetCarById), new { id = createdCar.CarID }, createdCar);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateCar(int id, [FromBody] UpdateCarDTO carDto)
        {
            if (carDto == null || carDto.CarID != id)
            {
                return BadRequest();
            }

            var existingCar = await _carService.layXeTheoIdAsync(id);
            if (existingCar == null)
            {
                return NotFound();
            }

            var updatedCar = await _carService.capNhatXeAsync(carDto);
            return Ok(updatedCar);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCar(int id)
        {
            var existingCar = await _carService.layXeTheoIdAsync(id);
            if (existingCar == null)
            {
                return NotFound();
            }

            var result = await _carService.xoaXeAsync(id);
            if (!result)
            {
                return StatusCode(500, "A problem happened while handling your request.");
            }

            return NoContent();
        }
    }
}