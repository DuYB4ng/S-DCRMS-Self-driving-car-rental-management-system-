using Microsoft.AspNetCore.Mvc;
using SDCRMS.Mappers;

namespace SDCRMS.Controllers
{
    [Route("api/customer")]
    [ApiController]
    public class CustomerController : ControllerBase
    {
        private readonly AppDbContext _context;
        public CustomerController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult Getall() //IActionResult là một interface trong ASP.NET Core MVC, dùng để định nghĩa kiểu dữ liệu trả về của một action (hàm trong Controller).
        {
            var customers = _context.Customers.ToList().
                Select(s=>s.ToCustomerDto());
            return Ok(customers);
        }

        [HttpGet("{id}")]
        public IActionResult GetById([FromRoute]int id) //[FromRoute] là một attribute trong ASP.NET Core, dùng để chỉ định rằng tham số của action sẽ được lấy từ route (đường dẫn URL) thay vì từ query string, body, hay header.
        {
            var customer = _context.Customers.Find(id);
            if (customer == null)
            {
                return NotFound();
            }
            return Ok(customer.ToCustomerDto());
        }
    }
}
