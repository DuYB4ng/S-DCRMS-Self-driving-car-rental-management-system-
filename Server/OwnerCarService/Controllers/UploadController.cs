using Microsoft.AspNetCore.Mvc;

namespace OwnerCarService.Controllers
{
    [ApiController]
    [Route("api/upload")]
    public class UploadController : ControllerBase
    {
        private readonly IWebHostEnvironment _environment;

        public UploadController(IWebHostEnvironment environment)
        {
            _environment = environment;
        }

        [HttpPost]
        public async Task<IActionResult> UploadImage([FromForm] IFormFile file)
        {
            try 
            {
                if (file == null || file.Length == 0)
                    return BadRequest("No file uploaded.");

                // Create uploads directory if it doesn't exist
                var webRoot = _environment.WebRootPath ?? Path.Combine(Directory.GetCurrentDirectory(), "wwwroot");
                var uploadsFolder = Path.Combine(webRoot, "images");
                
                if (!Directory.Exists(uploadsFolder))
                    Directory.CreateDirectory(uploadsFolder);

                // Generate unique filename
                var fileExt = Path.GetExtension(file.FileName);
                var uniqueFileName = Guid.NewGuid().ToString() + fileExt;
                var filePath = Path.Combine(uploadsFolder, uniqueFileName);

                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    await file.CopyToAsync(fileStream);
                }

                // Return the URL relative to server root
                // Ensure starting slash
                var url = $"/images/{uniqueFileName}";
                return Ok(new { url });
            }
            catch (Exception ex)
            {
                 return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
    }
}
