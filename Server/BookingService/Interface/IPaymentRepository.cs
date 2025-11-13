using BookingService.Dtos.Payment;
using BookingService.Models;

namespace BookingService.Interfaces
{
    public interface IPaymentRepository
    {
        Task<List<Payment>> GetAllAsync();
        Task<Payment?> GetByIdAsync(int id);
        Task<Payment?> CreateAsync(Payment PaymentModel);
        Task<Payment?> UpdateAsync(int id, UpdatePaymentRequestDto PaymentDto);

        Task<Payment?> DeleteAsync(int id);
    }
}