using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CustomerService.Models;
using CustomerService.Dtos.Customer;

namespace CustomerService.Interfaces
{
    public interface ICustomerRepository
    {
        Task<List<Customer>> getAllAsync();
        Task<Customer?> getByIdAsync(int id);
        Task<Customer> createAsync(CreateCustomerDto customerDto);
        Task<Customer?> updateAsync(int id, UpdateCustomerDto dto);
        Task<bool> deleteAsync(int id);
    }
}