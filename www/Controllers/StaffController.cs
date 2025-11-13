using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore; // thêm namespace này để dùng các hàm async của EF
using SDCRMS.Dtos.Staff;
using SDCRMS.Mappers;
using SDCRMS.Models;
using System.Threading.Tasks;
using System.Linq;
using SDCRMS.Interfaces;

namespace SDCRMS.Controllers
{
    [Route("api/staff")]
    [ApiController]
    public class StaffController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IStaffRepository _staffRepo;

        public StaffController(AppDbContext context, IStaffRepository staffRepo )
        {
            _context = context;
            _staffRepo = staffRepo;
        }

        // GET: api/staff
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var staffs = await _staffRepo.GetAllAsync();
            return Ok(staffs);
        }

        // GET: api/staff/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetID([FromRoute] int id)
        {
            var staff = await _staffRepo.GetByIdAsync(id);
            if (staff == null)
            {
                return NotFound();
            }
            return Ok(staff);
        }

        // POST: api/staff
        [HttpPost]
        public async Task<IActionResult> TaoStaff([FromBody] CreateStaffDto staffDto)
        {
            var staffModel = staffDto.ToStaffFromCreateDto();

         await _staffRepo.CreateAsync(staffModel);

            return CreatedAtAction(nameof(GetID), new { id = staffModel.ID }, staffModel.ToStaffDto());
        }

        // PUT: api/staff/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update([FromRoute] int id, [FromBody] UpdateStaffRequestDto updateDto)
        {
            var staffModel = await _staffRepo.UpdateAsync(id, updateDto);
            if (staffModel == null)
            {
                return NotFound();
            }

 
            await _context.SaveChangesAsync();
            return NoContent();
        }

        // DELETE: api/staff/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete([FromRoute] int id)
        {
            var staffModel = await _staffRepo.DeleteAsync(id);
            if (staffModel == null)
            {
                return NotFound();
            }


            return NoContent();
        }
    }
}
