using SDCRMS.Dtos.Staff;
using SDCRMS.Models;
using System.Reflection.Metadata.Ecma335;

namespace SDCRMS.Mappers.Staff
{
    public static class StaffMapper
    {
        public static Staff ToStaffFromCreateDto(this CreateStaffDto staffDto)
        {
            return new Staff
            {
                ID = staffDto.ID

            }; 
        }
    }
}
