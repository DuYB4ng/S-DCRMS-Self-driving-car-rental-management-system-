using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using Microsoft.AspNetCore.Mvc;
using SDCRMS.Models;

namespace SDCRMS.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AdminController : ControllerBase
    {
        private static List<Admin> admins = new List<Admin>();

        // GET: api/admin - giamSatHeThongVaPhanQuyen
        [HttpGet]
        public ActionResult<IEnumerable<Admin>> GetAdmins()
        {
            if (admins.Count == 0)
            {
                return NotFound("Không tìm thấy quản trị viên nào.");
            }

            return admins;
        }
    }
}
