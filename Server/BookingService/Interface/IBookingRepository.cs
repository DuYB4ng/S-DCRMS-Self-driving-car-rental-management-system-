using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BookingService.Models;
using BookingService.Dtos.Booking;
using Microsoft.AspNetCore.Mvc;
using Redis.Shared.Attributes;
namespace BookingService.Interfaces
{
    // public interface IBookingRepository
    // {
    //     Task<List<Booking>> getAllAsync();
    //     Task<Booking?> getByIdAsync(int id);
    //     Task<Booking> createAsync(CreateBookingDto dto, int customerId);
    //     Task<Booking?> updateAsync(int id, UpdateBookingDto dto);
    //     Task<bool> deleteAsync(int id);
    // }

     public interface IBookingRepository
    {
        // Cache list booking trong 300s -> REMOVED to fix stale data
        // [Cache(300)]
        Task<List<Booking>> getAllAsync();

        // Cache chi tiết 1 booking trong 300s -> REMOVED because Controller updates status directly via Context
        // [Cache(300)]
        Task<Booking?> getByIdAsync(int id);

        // Mỗi khi tạo booking mới → xóa toàn bộ cache booking
        [CacheEvict("BookingRepository*")]
        Task<Booking> createAsync(CreateBookingDto dto, int customerId);

        // Update booking → xoá cache list + detail
        [CacheEvict("BookingRepository*")]
        Task<Booking?> updateAsync(int id, UpdateBookingDto dto);

        // Delete booking → xoá cache list + detail
        [CacheEvict("BookingRepository*")]
        Task<bool> deleteAsync(int id);
    }
}