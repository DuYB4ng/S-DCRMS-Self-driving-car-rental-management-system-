
using Microsoft.AspNetCore.Mvc;
using SDCRMS.Dtos.Staff;
using SDCRMS.Mappers;
using SDCRMS.Models;
namespace SDCRMS.Controllers
{
    [Route("api/staff")]
    [ApiController]
    public class StaffController : ControllerBase
    {
        private readonly AppDbContext _context;
        public StaffController(AppDbContext context)
        {
            _context = context;
        }
        [HttpGet]
        //Lay danh sach
        public IActionResult GetAll()
        {
            var staff = _context.Staffs.ToList();

            return Ok(staff);
        }
        [HttpGet("{id}")]
        public IActionResult GetID([FromRoute] int id)
        {
            var staffs = _context.Staffs.Find(id);
            if (staffs == null)
            {
                return NotFound();
            }
            return Ok(staffs);
        }

        //Gữi thông báo 
        [HttpPost]
        public IActionResult taoStaff([FromBody] CreateStaffDto staffDto)
        {
            var staffModel = staffDto.ToStaffFromCreateDto();
            _context.Staffs.Add(staffModel);
            _context.SaveChanges();
            return CreatedAtAction(nameof(GetID), new { id = staffModel.ID }, staffModel.ToStaffDto());

        }
        [HttpPut]
        [Route("{id}")]
        public IActionResult Update([FromRoute] int id, [FromBody] UpdateStaffRequestDto updateDto)
        {
            var staffModel = _context.Staffs.FirstOrDefault(x => x.ID == id);
            if (staffModel == null)
            {
                return NotFound();
            }
            staffModel.FirstName = updateDto.FirstName;
            staffModel.LastName = updateDto.LastName;
            staffModel.Email = updateDto.Email;
            staffModel.PhoneNumber = updateDto.PhoneNumber;
            staffModel.Address = updateDto.Address;

            _context.SaveChanges();
            return NoContent();
        }

        [HttpDelete]
        [Route("{id}")]
        public IActionResult Delete([FromRoute] int id)
        {
            var staffModel = _context.Staffs.FirstOrDefault(x=> x.ID == id);
            if (staffModel != null)
            {
                return NotFound();
            }
            _context.Staffs.Remove(staffModel);
            _context.SaveChanges();
            return NoContent();
        }


    }
}
