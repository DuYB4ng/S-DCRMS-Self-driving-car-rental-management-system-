using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SDCRMS.DTOs.Admin;
using SDCRMS.Mapper;

namespace SDCRMS.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AdminController : ControllerBase
    {
        private readonly AppDbContext _context;

        public AdminController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/admin - giamSatHeThongVaPhanQuyen
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var admins = await _context.Admins.ToListAsync();
            var adminDtos = admins.Select(a => a.ToAdminDto()).ToList();
            return Ok(adminDtos);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById([FromRoute] int id)
        {
            var admin = await _context.Admins.FindAsync(id);
            if (admin == null)
                return NotFound(new { message = "Admin not found" });

            return Ok(admin.ToAdminDto());
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete([FromRoute] int id)
        {
            var admin = await _context.Admins.FindAsync(id);

            _context.Admins.Remove(admin!);
            await _context.SaveChangesAsync();

            return Ok(admin!.ToAdminDto());
        }
    }
}
