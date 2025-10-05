using SDCRMS.DTOs.Admin;
using SDCRMS.Models;

namespace SDCRMS.Mapper
{
    public static class AdminMapper
    {
        public static AdminDto ToAdminDto(this Admin admin)
        {
            return new AdminDto
            {
                UserId = admin.UserID,
                FirstName = admin.FirstName,
                LastName = admin.LastName,
                Email = admin.Email,
                Address = admin.Address,
                JoinedAt = admin.JoinDate,
                PhoneNumber = admin.PhoneNumber,
                Sex = admin.Sex,
                Birthday = admin.Birthday,
            };
        }
    }
}
