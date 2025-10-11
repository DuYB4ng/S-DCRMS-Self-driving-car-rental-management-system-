using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SDCRMS.Models;
using SDCRMS.Dtos.Customer;

namespace SDCRMS.Interfaces
{
    public interface ICustomerRepository
    {
        Task<List<Customer>> getAllAsync();
        Task<Customer?> getByIdAsync(int id);
        Task<Customer> createAsync(CreateCustomerDto dto);
        Task<Customer?> updateAsync(int id, UpdateCustomerDto dto);
        Task<bool> deleteAsync(int id);
    }
}