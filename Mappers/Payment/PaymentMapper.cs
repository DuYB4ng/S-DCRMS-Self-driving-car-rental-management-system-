using SDCRMS.Dtos.Payment;
using SDCRMS.Models;
namespace SDCRMS.Mappers;
    public static class PaymentMapper
    {
        public static Payment toPaymentDto(this CreatePaymentRequestDto paymentDto)
        {
            return new Payment
            {
                PaymentID= paymentDto.PaymentID,
                PaymentDate= paymentDto.PaymentDate,
                Amount= paymentDto.Amount,    
                Method= paymentDto.Method,   
                Status= paymentDto.Status,
                Booking= paymentDto.Booking,
                BookingID = paymentDto.BookingID,

            };
        }
    }

