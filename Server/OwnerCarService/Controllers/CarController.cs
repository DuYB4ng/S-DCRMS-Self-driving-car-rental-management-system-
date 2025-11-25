using Microsoft.AspNetCore.Mvc;
using OwnerCarService.Dtos.Car;
using OwnerCarService.Services;

namespace OwnerCarService.Controllers
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

        // GET: api/car
        [HttpGet]
        [ProducesResponseType(typeof(IEnumerable<CarDTO>), 200)]
        public async Task<IActionResult> GetAllCars()
        {
            var cars = await _carService.LayTatCaXeAsync();
            return Ok(cars);
        }

        // GET: api/car/available
        // Trả về danh sách xe đang hoạt động & không bảo trì
        [HttpGet("available")]
        [ProducesResponseType(typeof(IEnumerable<CarDTO>), 200)]
        public async Task<IActionResult> GetAvailableCars()
        {
            var cars = await _carService.LayTatCaXeKhongBaoTriAsync();
            return Ok(cars);
        }

        // GET: api/car/{id}
        [HttpGet("{id}")]
        [ProducesResponseType(typeof(CarDTO), 200)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> GetCarById(int id)
        {
            var car = await _carService.LayXeTheoIdAsync(id);
            if (car == null)
                return NotFound(new { message = $"Không tìm thấy xe có ID = {id}" });

            return Ok(car);
        }

        // POST: api/car
        [HttpPost]
        [ProducesResponseType(typeof(CarDTO), 201)]
        [ProducesResponseType(400)]
        public async Task<IActionResult> CreateCar([FromBody] CreateCarDTO carDto)
        {
            if (carDto == null)
                return BadRequest("Dữ liệu xe không hợp lệ.");

            try
            {
                var newCar = await _carService.ThemXeAsync(carDto);
                return CreatedAtAction(nameof(GetCarById), new { id = newCar.CarID }, newCar);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(new { message = ex.Message });
            }
            catch (Exception)
            {
                return StatusCode(500, "Đã xảy ra lỗi khi thêm xe mới.");
            }
        }

        // PUT: api/car/{id}
        [HttpPut("{id}")]
        [ProducesResponseType(typeof(CarDTO), 200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> UpdateCar(int id, [FromBody] UpdateCarDTO carDto)
        {
            if (carDto == null)
                return BadRequest("Dữ liệu xe không hợp lệ.");

            if (carDto.CarID != id)
                return BadRequest("ID xe trong URL không khớp với dữ liệu gửi lên.");

            var existingCar = await _carService.LayXeTheoIdAsync(id);
            if (existingCar == null)
                return NotFound(new { message = $"Không tìm thấy xe có ID = {id}" });

            var updatedCar = await _carService.CapNhatXeAsync(carDto);
            return Ok(updatedCar);
        }

        // DELETE: api/car/{id}
        [HttpDelete("{id}")]
        [ProducesResponseType(204)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> DeleteCar(int id)
        {
            var existingCar = await _carService.LayXeTheoIdAsync(id);
            if (existingCar == null)
                return NotFound(new { message = $"Không tìm thấy xe có ID = {id}" });

            var result = await _carService.XoaXeAsync(id);
            if (!result)
                return StatusCode(500, "Đã xảy ra lỗi trong quá trình xử lý yêu cầu.");

            return NoContent();
        }
    }
}
