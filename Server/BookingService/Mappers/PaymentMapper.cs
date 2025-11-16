
using BookingService.Dtos.Payment;
using BookingService.Models;
namespace BookingService.Mappers
{
    public static class PaymentMapper
    {
        public static Payment toPaymentDto(this Payment PaymentModel)
        {
            return new Payment
            {
                PaymentDate = PaymentModel.PaymentDate,
                Amount = PaymentModel.Amount,
                Method = PaymentModel.Method,
                Status = PaymentModel.Status,
                BookingID = PaymentModel.BookingID,

            };
        }
        public static Payment ToPaymentFromCreateDto(this CreatePaymentRequestDto paymentDto)
        {
            return new Payment
            {
                PaymentDate = paymentDto.PaymentDate,
                Amount = paymentDto.Amount,
                Method = paymentDto.Method,
                Status = paymentDto.Status,
                BookingID = paymentDto.BookingID,

            };
        }
    }

}