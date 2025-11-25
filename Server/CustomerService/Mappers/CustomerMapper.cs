using Microsoft.AspNetCore.Localization;
using CustomerService.Dtos.Customer;
using CustomerService.Models;

namespace CustomerService.Mappers
{
    public static class CustomerMapper
    {
        public static CustomerDto ToCustomerDto(this Customer customerModel)
        {
            return new CustomerDto
            {
                CustomerId = customerModel.CustomerId,
                FirebaseUid = customerModel.FirebaseUid,
                DrivingLicense = customerModel.DrivingLicense,
                LicenseIssueDate = customerModel.LicenseIssueDate,
                LicenseExpiryDate = customerModel.LicenseExpiryDate,
            };
        }
        
        public static Customer ToCreateCutomerDto(this CreateCustomerDto customerDto)
        {
            return new Customer
            {
                FirebaseUid    = customerDto.FirebaseUid,
                DrivingLicense= customerDto.DrivingLicense,
                LicenseIssueDate = customerDto.LicenseIssueDate,
                LicenseExpiryDate = customerDto.LicenseExpiryDate
            };
        }
    }
}