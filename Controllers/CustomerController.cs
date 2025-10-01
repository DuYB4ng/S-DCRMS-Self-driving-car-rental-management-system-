using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using Microsoft.AspNetCore.Mvc;
using SDCRMS.Models;

namespace SDCRMS.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CustomerController : ControllerBase
    {
        // Sử dụng CustomerVM để có CustomerID
        private static List<Customer> customerList = new List<Customer>();

        // GET: api/customer - Lấy tất cả customers
        [HttpGet]
        public ActionResult<IEnumerable<Customer>> GetCustomers()
        {
            return Ok(customerList);
        }

        // GET: api/customer/5 - Lấy customer theo ID
        [HttpGet("{id}")]
        public ActionResult<Customer> GetCustomer(int id)
        {
            var customer = customerList.FirstOrDefault(c => c.CustomerID == id);
            if (customer == null)
            {
                return NotFound($"Customer với ID {id} không tồn tại");
            }
            return Ok(customer);
        }

        // POST: api/customer - Tạo customer mới
        [HttpPost]
        public ActionResult<Customer> CreateCustomer([FromBody] Customer customer)
        {
            if (customer == null)
            {
                return BadRequest("Dữ liệu customer không hợp lệ");
            }

            // Tự động tạo CustomerID mới
            customer.CustomerID =
                customerList.Count > 0 ? customerList.Max(c => c.CustomerID) + 1 : 1;

            customerList.Add(customer);

            return CreatedAtAction(nameof(GetCustomer), new { id = customer.CustomerID }, customer);
        }

        // PUT: api/customer/5 - Cập nhật customer
        [HttpPut("{id}")]
        public IActionResult UpdateCustomer(int id, [FromBody] Customer customer)
        {
            var existingCustomer = customerList.FirstOrDefault(c => c.CustomerID == id);
            if (existingCustomer == null)
            {
                return NotFound($"Customer với ID {id} không tồn tại");
            }

            // Cập nhật thông tin customer
            existingCustomer.DrivingLisence = customer.DrivingLisence;
            existingCustomer.LisenceIssueDate = customer.LisenceIssueDate;
            existingCustomer.LisenceExpiryDate = customer.LisenceExpiryDate;

            return Ok(existingCustomer);
        }

        // DELETE: api/customer/5 - Xóa customer
        [HttpDelete("{id}")]
        public IActionResult DeleteCustomer(int id)
        {
            try
            {
                var deleteCustomer = customerList.SingleOrDefault(c => c.CustomerID == id);
                if (deleteCustomer == null)
                {
                    return NotFound($"Customer với ID {id} không tồn tại");
                }

                customerList.Remove(deleteCustomer);
                return Ok();
            }
            catch
            {
                return BadRequest("Yêu cầu xóa không hợp lệ");
            }
        }
    }
}
