using SDCRMS.Dtos.Payment;
using SDCRMS.Models;
namespace SDCRMS.Mappers
{
    public static class PaymentMapper
    {
        public static Payment toPaymentDto(this Payment stockModel)
        {
            return new Payment
            {
                PaymentID = stockModel.PaymentID,
                PaymentDate = stockModel.PaymentDate,
                Amount = stockModel.Amount,
                Method = stockModel.Method,
                Status = stockModel.Status,
                Booking = stockModel.Booking,
                BookingID = stockModel.BookingID,

            };
        }
        public static Payment ToPaymentFromCreateDto(this CreatePaymentRequestDto paymentDto)
        {
            return new Payment
            {
                PaymentID = paymentDto.PaymentID,
                PaymentDate = paymentDto.PaymentDate,
                Amount = paymentDto.Amount,
                Method = paymentDto.Method,
                Status = paymentDto.Status,
                Booking = paymentDto.Booking,
                BookingID = paymentDto.BookingID,

            };
        }
    }

}