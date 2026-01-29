using UserService.Dtos;

namespace UserService.Services
{
    public interface IUserLocationService
    {
        Task UpdateAsync(string firebaseUid, UpdateUserLocationDto dto);
    }
}