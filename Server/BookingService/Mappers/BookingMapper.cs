using BookingService.Dtos.Booking;
using BookingService.Models;

namespace BookingService.Mappers
{
    public static class BookingMapper
    {
        public static BookingDto ToBookingDto(this Booking booking)
        {
            return new Dtos.Booking.BookingDto
            {
                BookingID = booking.BookingID,
                StartDate = booking.StartDate,
                EndDate = booking.EndDate,
                CheckIn = booking.CheckIn,
                CheckOut = booking.CheckOut,
                Status = booking.Status,
                CustomerId = booking.CustomerId,
                CarId = booking.CarId,
                TotalPrice = booking.TotalPrice,
                DepositAmount = booking.DepositAmount,
                RefundAmount = booking.RefundAmount,
                CancellationFee = booking.CancellationFee,
                CreatedAt  = booking.CreatedAt
            };
        }
    }

    public static class CreateBookingMapper
    {
        public static Booking ToCreateBookingDto(this CreateBookingDto bookingDto)
        {
            return new Booking
            {
                StartDate = bookingDto.StartDate,
                EndDate = bookingDto.EndDate,
                CheckIn = false,
                CheckOut = false,
                Status = "Pending",
                CarId     = bookingDto.CarId,
                TotalPrice = bookingDto.TotalPrice
            };
        }
    }
}