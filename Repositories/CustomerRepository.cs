using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SDCRMS.Models;
using Microsoft.EntityFrameworkCore;
using SDCRMS.Dtos.Customer;
using SDCRMS.Mappers;

namespace SDCRMS.Repositories
{
    public interface ICustomerRepository
    {
        Task<List<Customer>> getAllAsync();
        Task<Customer?> getByIdAsync(int id);
        Task<Customer> createAsync(CreateCustomerDto customerDto);
        Task<Customer?> updateAsync(int id, UpdateCustomerDto dto);
        Task<bool> deleteAsync(int id);
    }
    public class CustomerRepository : ICustomerRepository
    {
        private readonly AppDbContext _context;
        public CustomerRepository(AppDbContext context)
        {
            _context = context;
        }

        public Task<List<Customer>> getAllAsync()
        {
            return _context.Customers.ToListAsync();
        }

        public Task<Customer?> getByIdAsync(int id)
        {
            return _context.Customers.FindAsync(id).AsTask();
        }

        public async Task<Customer> createAsync(CreateCustomerDto customerDto)
        {
            // Map DTO -> Entity (điền đúng các field của bạn)
            var customerModel = customerDto.ToCreateCutomerDto();
            await _context.Customers.AddAsync(customerModel);
            await _context.SaveChangesAsync();
            return customerModel; 
        }

        public async Task<Customer?> updateAsync(int id, UpdateCustomerDto dto)
        {
            var existing = await _context.Customers.FindAsync(id).AsTask();
            if (existing is null) return null;
            existing.FirstName = dto.FirstName;
            existing.LastName = dto.LastName;
            existing.Email = dto.Email;
            existing.PhoneNumber = dto.PhoneNumber;
            existing.Address = dto.Address;
            existing.DrivingLicense = dto.DrivingLicense;
            existing.LicenseIssueDate = dto.LicenseIssueDate;
            existing.LicenseExpiryDate = dto.LicenseExpiryDate;

            await _context.SaveChangesAsync();
            return existing;
        }
        public async Task<bool> deleteAsync(int id)
        {
            var existing = await _context.Customers.FindAsync(id);
            if (existing is null) return false;

            _context.Customers.Remove(existing);
            await _context.SaveChangesAsync();
            return true;
        }

    }
}