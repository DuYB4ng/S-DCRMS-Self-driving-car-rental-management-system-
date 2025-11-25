using Microsoft.AspNetCore.Mvc;
using SDCRMS.Dtos.Staff;
using SDCRMS.Interfaces;
using SDCRMS.Mappers;
using System.Net.Http;
using System.Threading.Tasks;

namespace SDCRMS.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StaffController : ControllerBase
    {
        private readonly IStaffRepository _staffRepo;
        private readonly HttpClient _httpClient; // ✅ khai báo rõ ràng

        // ✅ Constructor inject đúng biến và đặt tên chuẩn
        public StaffController(IStaffRepository staffRepo, IHttpClientFactory httpClientFactory)
        {
            _staffRepo = staffRepo;
            _httpClient = httpClientFactory.CreateClient(); // ✅ tạo HttpClient đúng cách
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var staffs = await _staffRepo.GetAllAsync();
            return Ok(staffs.Select(s => s.ToStaffDto()));
        }

        [HttpGet("{id:int}")]
        public async Task<IActionResult> GetById(int id)
        {
            var staff = await _staffRepo.GetByIdAsync(id);
            if (staff == null)
                return NotFound(new { message = "Staff not found" });

            return Ok(staff.ToStaffDto());
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateStaffDto dto)
        {
            var staffModel = dto.ToStaffFromCreateDto();
            var created = await _staffRepo.CreateAsync(staffModel);

            if (created == null)
                return StatusCode(500, new { message = "Failed to create staff" });

            return CreatedAtAction(nameof(GetById), new { id = created.StaffId }, created.ToStaffDto());
        }

        [HttpPut("{id:int}")]
        public async Task<IActionResult> Update(int id, [FromBody] UpdateStaffRequestDto dto)
        {
            var updated = await _staffRepo.UpdateAsync(id, dto);
            if (updated == null)
                return NotFound(new { message = "Staff not found" });

            return Ok(updated.ToStaffDto());
        }

        [HttpDelete("{id:int}")]
        public async Task<IActionResult> Delete(int id)
        {
            var deleted = await _staffRepo.DeleteAsync(id);
            if (deleted == null)
                return NotFound(new { message = "Staff not found" });

            return Ok(new { message = "Staff deleted successfully" });
        }

        // ✅ Optional - chỉ dùng nếu NotificationService có thật
        [HttpGet("{id}/notifications")]
        public async Task<IActionResult> GetStaffNotifications(int id)
        {
            var staff = await _staffRepo.GetByIdAsync(id);
            if (staff == null) return NotFound();

            var response = await _httpClient.GetAsync(
                $"http://notificationservice:8086/api/notifications?userId={staff.FirebaseUid}"
            );

            if (!response.IsSuccessStatusCode)
                return StatusCode((int)response.StatusCode, "Failed to get notifications.");

            var data = await response.Content.ReadAsStringAsync();
            return Content(data, "application/json");
        }
    }
}
