
using paymentServices.Dtos.Payment;
using paymentServices.Models;
namespace paymentService.Mappers
{
    public static class PaymentMapper
    {
        public static Payment toPaymentDto(this Payment PaymentModel)
        {
            return new Payment
            {
                PaymentID = PaymentModel.PaymentID,
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
                PaymentID = paymentDto.PaymentID,
                PaymentDate = paymentDto.PaymentDate,
                Amount = paymentDto.Amount,
                Method = paymentDto.Method,
                Status = paymentDto.Status,

                BookingID = paymentDto.BookingID,

            };
        }
    }

}