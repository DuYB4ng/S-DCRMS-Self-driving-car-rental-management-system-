using SDCRMS.Dtos.Staff;
using SDCRMS.Models;

namespace SDCRMS.Mappers
{
    public static class StaffMapper
    {
        // Map từ CreateStaffDto sang Staff (khi tạo mới)
        public static Staff ToStaffFromCreateDto(this CreateStaffDto dto)
        {
            return new Staff
            {
                FirebaseUid = string.IsNullOrWhiteSpace(dto.FirebaseUid)
                    ? Guid.NewGuid().ToString() // tạo UID tạm nếu chưa có FirebaseUid
                    : dto.FirebaseUid,

                FullName = dto.FullName,
                Email = dto.Email,
                PhoneNumber = dto.PhoneNumber,
                Address = dto.Address,
                Position = dto.Position,
                Status = "Active",
                HireDate = DateTime.UtcNow
            };
        }

        // Map từ Staff model sang StaffDto (khi trả về client)
        public static StaffDto ToStaffDto(this Staff staff)
        {
            return new StaffDto
            {
                StaffId = staff.StaffId,
                FirebaseUid = staff.FirebaseUid,
                FullName = staff.FullName,
                Email = staff.Email,
                PhoneNumber = staff.PhoneNumber,
                Address = staff.Address,
                Position = staff.Position,
                HireDate = staff.HireDate,
                Status = staff.Status
            };
        }
    }
}
