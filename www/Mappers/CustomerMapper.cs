using Microsoft.AspNetCore.Localization;
using SDCRMS.Dtos.Customer;
using SDCRMS.Models;

namespace SDCRMS.Mappers
{
    public static class CustomerMapper
    {
        public static CustomerDto ToCustomerDto(this Customer customerModel) //this được hiểu là mở rộng extension method cho lớp Customer
        {
            return new CustomerDto
            {
               ID = customerModel.ID,
               Username = customerModel.Username,
               FirstName = customerModel.FirstName,
               LastName = customerModel.LastName,
               Email = customerModel.Email,
               Sex = customerModel.Sex,
               PhoneNumber = customerModel.PhoneNumber,
               Address = customerModel.Address,
               DrivingLicense = customerModel.DrivingLicense,
               LicenseExpiryDate = customerModel.LicenseExpiryDate,
               JoinDate = customerModel.JoinDate
            };
        }
        
        public static Customer ToCreateCutomerDto(this CreateCustomerDto customerDto)
        {
            return new Customer
            {
                Username = customerDto.Username,
                Password = customerDto.Password,
                FirstName = customerDto.FirstName,
                LastName= customerDto.LastName,
                Sex = customerDto.Sex,
                Email = customerDto.Email,
                PhoneNumber = customerDto.PhoneNumber,
                Address = customerDto.Address,
                DrivingLicense= customerDto.DrivingLicense,
                LicenseIssueDate = customerDto.LicenseIssueDate,
                LicenseExpiryDate = customerDto.LicenseExpiryDate
            };
        }
    }
}
