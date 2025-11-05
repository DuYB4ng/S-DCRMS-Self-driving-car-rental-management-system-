using SDCRMS.DTOs.Admin;
using SDCRMS.Models;
using SDCRMS.Models.Enums;

namespace SDCRMS.Mapper
{
    public static class AdminMapper
    {
        public static AdminDto ToAdminDto(this Admin admin)
        {
            return new AdminDto
            {
                UserID = admin.UserID,
                Role = admin.Role.ToString(),
                FirstName = admin.FirstName,
                LastName = admin.LastName,
                Email = admin.Email,
                Address = admin.Address,
                JoinDate = admin.JoinDate,
                PhoneNumber = admin.PhoneNumber,
                Sex = admin.Sex,
                Birthday = admin.Birthday,
            };
        }
    }

    public static class CreateAdminDtoMapper
    {
        public static Admin ToAdmin(this CreateAdminDto dto)
        {
            return new Admin
            {
                FirstName = dto.FirstName,
                LastName = dto.LastName,
                Email = dto.Email,
                Address = dto.Address,
                PhoneNumber = dto.PhoneNumber,
                Sex = dto.Sex,
                Birthday = dto.Birthday,
            };
        }
    }
}
