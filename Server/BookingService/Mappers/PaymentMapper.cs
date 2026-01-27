
using BookingService.Dtos.Payment;
using BookingService.Models;
namespace BookingService.Mappers
{
    public static class PaymentMapper
    {
        public static BookingPayment toPaymentDto(this BookingPayment PaymentModel)
        {
            return new BookingPayment
            {
                PaymentDate = PaymentModel.PaymentDate,
                Amount = PaymentModel.Amount,
                Method = PaymentModel.Method,
                Status = PaymentModel.Status,
                BookingID = PaymentModel.BookingID,

            };
        }
        public static BookingPayment ToPaymentFromCreateDto(this CreatePaymentRequestDto paymentDto)
        {
            return new BookingPayment
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