using Microsoft.AspNetCore.Localization;
using CustomerService.Dtos.Customer;
using CustomerService.Models;

namespace CustomerService.Mappers
{
    public static class CustomerMapper
    {
        public static CustomerDto ToCustomerDto(this Customer customerModel) //this được hiểu là mở rộng extension method cho lớp Customer
        {
            return new CustomerDto
            {
               DrivingLicense = customerModel.DrivingLicense,
               LicenseIssueDate = customerModel.LicenseIssueDate,
               LicenseExpiryDate = customerModel.LicenseExpiryDate,
            };
        }
        
        public static Customer ToCreateCutomerDto(this CreateCustomerDto customerDto)
        {
            return new Customer
            {
                DrivingLicense= customerDto.DrivingLicense,
                LicenseIssueDate = customerDto.LicenseIssueDate,
                LicenseExpiryDate = customerDto.LicenseExpiryDate
            };
        }
    }
}