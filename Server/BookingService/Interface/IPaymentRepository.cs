using BookingService.Dtos.Payment;
using BookingService.Models;

namespace BookingService.Interfaces
{
    public interface IPaymentRepository
    {
        Task<List<BookingPayment>> GetAllAsync();
        Task<BookingPayment?> GetByIdAsync(int id);
        Task<BookingPayment?> CreateAsync(BookingPayment PaymentModel);
        Task<BookingPayment?> UpdateAsync(int id, UpdatePaymentRequestDto PaymentDto);

        Task<BookingPayment?> DeleteAsync(int id);
    }
}