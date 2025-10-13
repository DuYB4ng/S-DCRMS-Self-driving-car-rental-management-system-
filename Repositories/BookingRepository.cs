using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SDCRMS.Interfaces;
using SDCRMS.Models;
using Microsoft.EntityFrameworkCore;
using SDCRMS.Dtos.Booking;
using SDCRMS.Mappers;
using Microsoft.AspNetCore.Mvc;

namespace SDCRMS.Repositories
{
    public class BookingRepository : IBookingRepository
    {
        private readonly AppDbContext _context;
        public BookingRepository(AppDbContext context)
        {
            _context = context;
        }
        public Task<List<Booking>> getAllAsync()
        {
            return _context.Bookings.ToListAsync();
        }
        public Task<Booking?> getByIdAsync(int id)
        {
            return _context.Bookings.FindAsync(id).AsTask();
        }
        public async Task<Booking> createAsync(CreateBookingDto bookingDto)
        {
            var bookingModel = bookingDto.ToCreateBookingDto();
            await _context.Bookings.AddAsync(bookingModel);
            await _context.SaveChangesAsync();
            return bookingModel;
        }
        public async Task<Booking?> updateAsync(int id, UpdateBookingDto dto)
        {
            var existing = await _context.Bookings.FindAsync(id).AsTask();
            if (existing is null) return null;
            existing.StartDate = dto.StartDate;
            existing.EndDate = dto.EndDate;
            existing.CheckIn = dto.CheckIn;
            existing.CheckOut = dto.CheckOut;
            await _context.SaveChangesAsync();
            return existing;
        }
        public async Task<bool> deleteAsync(int id)
        {
            var existing = await _context.Bookings.FindAsync(id);
            if (existing is null) return false;
            _context.Bookings.Remove(existing);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}