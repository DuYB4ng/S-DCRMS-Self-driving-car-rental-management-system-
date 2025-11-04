using Microsoft.AspNetCore.Mvc;
using OwnerCarService.Dtos;
using OwnerCarService.Services;

namespace OwnerCarService.Controllers
{
    [ApiController]
    [Route("api/location")]
    public class CarLocationController : ControllerBase
    {
        private readonly KafkaProducer _producer;
        private readonly ILogger<CarLocationController> _logger;

        public CarLocationController(KafkaProducer producer, ILogger<CarLocationController> logger)
        {
            _producer = producer;
            _logger = logger;
        }

        [HttpPost]
        public async Task<IActionResult> UpdateLocation([FromBody] CarLocationDto carLocation)
        {
            if (carLocation == null)
                return BadRequest("Invalid car location data");

            _logger.LogInformation("📦 Received from API: CarID={CarID}, Lat={Lat}, Lng={Lng}, Speed={Speed}",
                carLocation.CarID, carLocation.Latitude, carLocation.Longitude, carLocation.Speed);

            try
            {
                await _producer.SendMessageAsync("car_location", carLocation);
                _logger.LogInformation("Sent car location for CarID {CarID}", carLocation.CarID);

                return Ok(new { message = "Car location sent to Kafka" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to send car location to Kafka");
                return StatusCode(500, new { error = "Failed to send message" });
            }
        }
    }
}
