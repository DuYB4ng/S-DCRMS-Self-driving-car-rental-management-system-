using Microsoft.AspNetCore.Mvc;
using SDCRMS.Mappers;
using SDCRMS.Dtos.Customer;
using Microsoft.EntityFrameworkCore;
using SDCRMS.Models;
using SDCRMS.Services;

namespace SDCRMS.Controllers
{
    [Route("api/customer")]
    [ApiController]
    public class CustomerController : ControllerBase
    {
        private readonly ICustomerService _customerService;

        public CustomerController(ICustomerService customerService)
        {
            _customerService = customerService;
        }
        [HttpGet]
        public async Task<IActionResult> Getall() //IActionResult là một interface trong ASP.NET Core MVC, dùng để định nghĩa kiểu dữ liệu trả về của một action (hàm trong Controller).
        {
            var customers = await _customerService.layTatCaCustomerAsync();
            return Ok(customers);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById([FromRoute]int id) //[FromRoute] là một attribute trong ASP.NET Core, dùng để chỉ định rằng tham số của action sẽ được lấy từ route (đường dẫn URL) thay vì từ query string, body, hay header.
        {
            var customer = await _customerService.layCustomerTheoIdAsync(id);
            if (customer == null)
            {
                return NotFound();
            }
            return Ok(customer);
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody]CreateCustomerDto customerDto)
        {
            var customerModel = await _customerService.themCustomerAsync(customerDto);
            return Ok(customerModel);
        }

        [HttpPut]
        [Route("{id}")]
        public async Task<IActionResult> Update([FromRoute]int id, [FromBody] UpdateCustomerDto customerDto)
        {
            var existingCustomer = await _customerService.capNhatCustomerAsync(id, customerDto);
            if (existingCustomer is null) return NotFound();
            return Ok(existingCustomer);
        }

        [HttpDelete]
        [Route("{id}")]
        public async Task<IActionResult> Delete([FromRoute]int id)
        {
            var existingCustomer = await _customerService.xoaCustomerAsync(id);
            if (!existingCustomer)
            {
                return NotFound();
            }
            return NoContent();
        }
    }
}
