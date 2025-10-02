using SDCRMS.Dtos.Customer;
using SDCRMS.Models;

namespace SDCRMS.Mappers
{
    public static class CustomerMapper
    {
        public static CustomerDto ToCustomerDto(this Customer customerModel)
        {
            return new CustomerDto
            {
               ID = customerModel.ID,
               Username = customerModel.Username,
               FirstName = customerModel.FirstName,
               LastName = customerModel.LastName,
               Email = customerModel.Email,
               PhoneNumber = customerModel.PhoneNumber,
               Address = customerModel.Address,
               DrivingLicense = customerModel.DrivingLicense,
               LisenceExpiryDate = customerModel.LicenseExpiryDate,
               JoinDate = customerModel.JoinDate
            };
        }
    }
}
