using Microsoft.EntityFrameworkCore;
using BookingService.Dtos.Payment;
using BookingService.Interfaces;
using BookingService.Models;

namespace BookingService.Repositories
{
    public class PaymentRepository : IPaymentRepository
    {
        private readonly AppDbContext _context;
        public PaymentRepository(AppDbContext context)
        {
            _context = context;
        }
        public async Task<BookingPayment?> CreateAsync(BookingPayment PaymentModel)
        {
            await _context.Payments.AddAsync(PaymentModel);
            await _context.SaveChangesAsync();
            return PaymentModel;
        }

        public async Task<BookingPayment?> DeleteAsync(int id)
        {
            var paymentModel = await _context.Payments.FirstOrDefaultAsync(x => x.PaymentID == id);
            if (paymentModel == null)
            {
                return null;
            }
            _context.Payments.Remove(paymentModel);
            await _context.SaveChangesAsync();
            return paymentModel;
        }

        public async Task<List<BookingPayment>> GetAllAsync()
        {
          return await _context.Payments.ToListAsync();
        }

        public async Task<BookingPayment?> GetByIdAsync(int id)
        {
            return await _context.Payments.FindAsync(id);
        }

        public async Task<BookingPayment?> UpdateAsync(int id, UpdatePaymentRequestDto PaymentDto)
        {
            var existingPayment = await _context.Payments.FirstOrDefaultAsync(x=>x.PaymentID == id);
            if (existingPayment == null)
            {
                return null;

            }
            existingPayment.PaymentDate = PaymentDto.PaymentDate;
            existingPayment.Amount = PaymentDto.Amount;
            existingPayment.Method = PaymentDto.Method;
            existingPayment.Status = PaymentDto.Status;
            existingPayment.BookingID = PaymentDto.BookingID;
           
            await _context.SaveChangesAsync();
            return existingPayment;

        }
    }
}