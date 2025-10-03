using Microsoft.AspNetCore.Mvc;
using SDCRMS.Mappers;
using SDCRMS.Dtos.Customer;

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

        [HttpPost]
        public IActionResult Create([FromBody]CreateCustomerDto customerDto)
        {
            var customerModel = customerDto.ToCreateCutomerDto();
            _context.Customers.Add(customerModel);
            _context.SaveChanges();
            return CreatedAtAction(nameof(GetById), new { id = customerModel.ID }, customerModel.ToCustomerDto());
        }

        [HttpPut]
        [Route("{id}")]
        public IActionResult Update([FromRoute]int id, [FromBody] UpdateCustomerDto customerDto)
        {
            var existingCustomer = _context.Customers.Find(id); //var customerModel = _context.Customers.FirstOrDefault(c => c.ID == id);
            if (existingCustomer == null)
            {
                return NotFound();
            }
            // Cập nhật các thuộc tính của existingCustomer từ customerDto
            existingCustomer.FirstName = customerDto.FirstName;
            existingCustomer.LastName = customerDto.LastName;
            existingCustomer.Email = customerDto.Email;
            existingCustomer.PhoneNumber = customerDto.PhoneNumber;
            existingCustomer.Address = customerDto.Address;
            existingCustomer.DrivingLicense = customerDto.DrivingLicense;
            existingCustomer.LicenseIssueDate = customerDto.LicenseIssueDate;
            existingCustomer.LicenseExpiryDate = customerDto.LicenseExpiryDate;
            _context.SaveChanges();
            return Ok(existingCustomer.ToCustomerDto());
        }

        [HttpDelete]
        [Route("{id}")]
        public IActionResult Delete([FromRoute]int id)
        {
            var existingCustomer = _context.Customers.Find(id);
            if (existingCustomer == null)
            {
                return NotFound();
            }
            _context.Customers.Remove(existingCustomer);
            _context.SaveChanges();
            return NoContent();
        }
    }
}
