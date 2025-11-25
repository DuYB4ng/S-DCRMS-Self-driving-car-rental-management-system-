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
                FirebaseUid = dto.FirebaseUid
            };
        }

        // Map từ Staff model sang StaffDto (khi trả về client)
        public static StaffDto ToStaffDto(this Staff staff)
        {
            return new StaffDto
            {
                StaffId = staff.StaffId,
                FirebaseUid = staff.FirebaseUid
            };
        }
    }
}
