using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SDCRMS.Models;
using SDCRMS.Dtos.Booking;
using Microsoft.AspNetCore.Mvc;

namespace SDCRMS.Interfaces
{
    public interface IBookingRepository
    {
        Task<List<Booking>> getAllAsync();
        Task<Booking?> getByIdAsync(int id);
        Task<Booking> createAsync(CreateBookingDto dto);
        Task<Booking?> updateAsync(int id, UpdateBookingDto dto);
        Task<bool> deleteAsync(int id);
    }
}