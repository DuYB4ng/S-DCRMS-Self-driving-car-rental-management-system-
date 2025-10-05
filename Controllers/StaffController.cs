
using Microsoft.AspNetCore.Mvc;
using SDCRMS.Dtos.Staff;
using SDCRMS.Mappers.Staff;
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
            var customers = _context.Customers.ToList();

            return Ok(customers);
        }
        [HttpGet("{id}")]
        public IActionResult GetID([FromRoute] int id)
        {
            var customer = _context.Customers.Find(id);
            if (customer == null)
            {
                return NotFound();
            }
            return Ok(customer);
        }

        //Gữi thông báo 
        [HttpPost]
        public IActionResult taoStaff([FromBody] CreateStaffDto staffDto)
        {
            var StaffModel = staffDto.
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
