using Microsoft.AspNetCore.Mvc;
using OwnerCarService.Services;

namespace OwnerCarService.Controllers
{
    [ApiController]
    [Route("api/location")]
    public class CarLocationController : ControllerBase
    {
        private readonly KafkaProducer _producer;

        public CarLocationController(KafkaProducer producer)
        {
            _producer = producer;
        }

        [HttpPost]
        public async Task<IActionResult> UpdateLocation([FromBody] object carLocation)
        {
            await _producer.SendMessageAsync("car_location", carLocation);
            return Ok(new { message = "Car location sent to Kafka" });
        }
    }
}
