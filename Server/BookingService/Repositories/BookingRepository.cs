using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BookingService.Interfaces;
using BookingService.Models;
using Microsoft.EntityFrameworkCore;
using BookingService.Dtos.Booking;
using BookingService.Mappers;
using Microsoft.AspNetCore.Mvc;

namespace BookingService.Repositories
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
			return _context.Bookings
				.OrderByDescending(b => b.BookingID)
				.ToListAsync();
		}
		public Task<Booking?> getByIdAsync(int id)
		{
			return _context.Bookings.FindAsync(id).AsTask();
		}
		public async Task<Booking> createAsync(CreateBookingDto bookingDto, int customerId)
		{
			var bookingModel = bookingDto.ToCreateBookingDto();
			bookingModel.CustomerId = customerId;
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
			existing.Status = dto.Status;
			existing.CarId     = dto.CarId;
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