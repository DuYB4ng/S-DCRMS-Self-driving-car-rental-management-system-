using SDCRMS.Dtos.Customer;
using SDCRMS.Mappers;
using SDCRMS.Repositories;

namespace SDCRMS.Services
{
    public interface ICustomerService
    {
        Task<List<CustomerDto>> layTatCaCustomerAsync();
        Task<CustomerDto?> layCustomerTheoIdAsync(int id);
        Task<CustomerDto> themCustomerAsync(CreateCustomerDto customerDto);
        Task<CustomerDto?> capNhatCustomerAsync(int id, UpdateCustomerDto dto);
        Task<bool> xoaCustomerAsync(int id);
    }
    public class CustomerService: ICustomerService
    {
        private readonly AppDbContext _context;
        private readonly ICustomerRepository _customerRepo;

        public CustomerService(AppDbContext context, ICustomerRepository customerRepo)
        {
            _context = context;
            _customerRepo = customerRepo;
        }
        public async Task<List<CustomerDto>> layTatCaCustomerAsync()
        {
            var customers = await _customerRepo.getAllAsync();
            return customers.Select(c => c.ToCustomerDto()).ToList();
        }
        public async Task<CustomerDto?> layCustomerTheoIdAsync(int id)
        {
            var customer = await _customerRepo.getByIdAsync(id);
            if (customer == null)
            {
                return null;
            }
            return customer.ToCustomerDto();
        }
        public async Task<CustomerDto> themCustomerAsync(CreateCustomerDto customerDto)
        {
            var customerModel = await _customerRepo.createAsync(customerDto);
            return customerModel.ToCustomerDto();
        }
        public async Task<CustomerDto?> capNhatCustomerAsync(int id, UpdateCustomerDto dto)
        {
            var existingCustomer = await _customerRepo.updateAsync(id, dto);
            if (existingCustomer is null) return null;
            return existingCustomer.ToCustomerDto();
        }
        public async Task<bool> xoaCustomerAsync(int id)
        {
            var existingCustomer = await _customerRepo.deleteAsync(id);
            return existingCustomer;
        }
    }
}