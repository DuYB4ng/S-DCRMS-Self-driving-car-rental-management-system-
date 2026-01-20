using Microsoft.AspNetCore.Mvc;
using ITSService.Models;

namespace ITSService.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TrafficSignController : ControllerBase
    {
        private readonly ILogger<TrafficSignController> _logger;

        public TrafficSignController(ILogger<TrafficSignController> logger)
        {
            _logger = logger;
        }

        [HttpPost("recognize")]
        public ActionResult<TrafficSignRecognitionResponse> Recognize([FromBody] TrafficSignRecognitionRequest request)
        {
            _logger.LogInformation("Received traffic sign recognition request");

            // TODO: Integrate actual ML model here (e.g., call Python service or TensorFlow.NET)
            // For now, return a mock response based on random logic or input
            
            var response = new TrafficSignRecognitionResponse
            {
                SignType = "SpeedLimit50",
                Confidence = 0.95,
                Message = "Detected Speed Limit 50 sign"
            };

            return Ok(response);
        }
    }
}
