using Microsoft.AspNetCore.Mvc;
using SDCRMS.Mappers;
using SDCRMS.Dtos.Customer;
using Microsoft.EntityFrameworkCore;
using SDCRMS.Interfaces;

namespace SDCRMS.Controllers
{
    [Route("api/customer")]
    [ApiController]
    public class CustomerController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly ICustomerRepository _customerRepo;

        public CustomerController(AppDbContext context, ICustomerRepository customerRepo)
        {
            _context = context;
            _customerRepo = customerRepo;
        }

        [HttpGet]
        public async Task<IActionResult> Getall() //IActionResult là một interface trong ASP.NET Core MVC, dùng để định nghĩa kiểu dữ liệu trả về của một action (hàm trong Controller).
        {
            var customers = await _customerRepo.getAllAsync();
            var dtoCustomer = customers.Select(s=>s.ToCustomerDto());
            return Ok(customers);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById([FromRoute]int id) //[FromRoute] là một attribute trong ASP.NET Core, dùng để chỉ định rằng tham số của action sẽ được lấy từ route (đường dẫn URL) thay vì từ query string, body, hay header.
        {
            var customer = await _customerRepo.getByIdAsync(id);
            if (customer == null)
            {
                return NotFound();
            }
            return Ok(customer.ToCustomerDto());
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody]CreateCustomerDto customerDto)
        {
            var customerModel = await _customerRepo.createAsync(customerDto);
            return CreatedAtAction(nameof(GetById), new { id = customerModel.ID }, customerModel);
        }

        [HttpPut]
        [Route("{id}")]
        public async Task<IActionResult> Update([FromRoute]int id, [FromBody] UpdateCustomerDto customerDto)
        {
            var existingCustomer = await _customerRepo.updateAsync(id, customerDto);
            if (existingCustomer is null) return NotFound();
            return Ok(existingCustomer.ToCustomerDto());
        }

        [HttpDelete]
        [Route("{id}")]
        public async Task<IActionResult> Delete([FromRoute]int id)
        {
            var existingCustomer = await _customerRepo.deleteAsync(id);
            if (!existingCustomer) return NotFound();
            return NoContent();
        }
    }
}
