using SDCRMS.Dtos.Customer;
using SDCRMS.Dtos.Staff;
using SDCRMS.Models;
using System.Reflection.Metadata.Ecma335;

namespace SDCRMS.Mappers
{
    public static class StaffMapper
    {
        public static Staff ToStaffDto(this Staff staffModel)
        {
            return new Staff
            {
                ID = staffModel.ID,
                Username = staffModel.Username,
                Password = staffModel.Password,
                FirstName = staffModel.FirstName,
                LastName = staffModel.LastName,
                Sex = staffModel.Sex,
                Email = staffModel.Email,
                PhoneNumber = staffModel.PhoneNumber,
                Address = staffModel.Address,

            };
        }
        public static Staff ToStaffFromCreateDto(this CreateStaffDto staffDto)
        {
            return new Staff
            {
                Username = staffDto.Username,
                Password = staffDto.Password,
                FirstName = staffDto.FirstName,
                LastName = staffDto.LastName,
                Sex = staffDto.Sex,
                Email = staffDto.Email,
                PhoneNumber = staffDto.PhoneNumber,
                Address = staffDto.Address,

            }; 
        }
    }
}
