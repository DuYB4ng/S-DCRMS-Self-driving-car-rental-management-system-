using Microsoft.AspNetCore.Mvc;
using SDCRMS.Mappers;
using SDCRMS.Dtos.Customer;
using Microsoft.EntityFrameworkCore;

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
        public async Task<IActionResult> Getall() //IActionResult là một interface trong ASP.NET Core MVC, dùng để định nghĩa kiểu dữ liệu trả về của một action (hàm trong Controller).
        {
            var customers = await _context.Customers.ToListAsync();
            var dtoCustomer = customers.Select(s=>s.ToCustomerDto());
            return Ok(customers);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById([FromRoute]int id) //[FromRoute] là một attribute trong ASP.NET Core, dùng để chỉ định rằng tham số của action sẽ được lấy từ route (đường dẫn URL) thay vì từ query string, body, hay header.
        {
            var customer = await _context.Customers.FindAsync(id);
            if (customer == null)
            {
                return NotFound();
            }
            return Ok(customer.ToCustomerDto());
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody]CreateCustomerDto customerDto)
        {
            var customerModel = customerDto.ToCreateCutomerDto();
            await _context.Customers.AddAsync(customerModel);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetById), new { id = customerModel.ID }, customerModel.ToCustomerDto());
        }

        [HttpPut]
        [Route("{id}")]
        public async Task<IActionResult> Update([FromRoute]int id, [FromBody] UpdateCustomerDto customerDto)
        {
            var existingCustomer = await _context.Customers.FindAsync(id); //var customerModel = _context.Customers.FirstOrDefault(c => c.ID == id);
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
            await _context.SaveChangesAsync();
            return Ok(existingCustomer.ToCustomerDto());
        }

        [HttpDelete]
        [Route("{id}")]
        public async Task<IActionResult> Delete([FromRoute]int id)
        {
            var existingCustomer = await _context.Customers.FindAsync(id);
            if (existingCustomer == null)
            {
                return NotFound();
            }
            _context.Customers.Remove(existingCustomer);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
