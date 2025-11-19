using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BookingService.Models;
using BookingService.Dtos.Booking;
using Microsoft.AspNetCore.Mvc;

namespace BookingService.Interfaces
{
    public interface IBookingRepository
    {
        Task<List<Booking>> getAllAsync();
        Task<Booking?> getByIdAsync(int id);
        Task<Booking> createAsync(CreateBookingDto dto, int customerId);
        Task<Booking?> updateAsync(int id, UpdateBookingDto dto);
        Task<bool> deleteAsync(int id);
    }
}