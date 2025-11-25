using Microsoft.AspNetCore.Mvc;
using UserService.Models;
using UserService.Services;

namespace UserService.Controllers
{
    [ApiController]
    [Route("api/users")]
    public class UserController : ControllerBase
    {
        private readonly IUserService _userService;

        public UserController(IUserService userService)
        {
            _userService = userService;
        }

        public class PromoteUserDto
        {
            public string? Role { get; set; }
        }

        [HttpGet]
        public async Task<ActionResult<List<User>>> GetAll()
        {
            var users = await _userService.GetAllAsync();
            return Ok(users);
        }

        [HttpGet("firebase/{firebaseUid}")]
        public async Task<ActionResult<User?>> GetByFirebaseUid(string firebaseUid)
        {
            var user = await _userService.GetByFirebaseUidAsync(firebaseUid);
            if (user == null)
            {
                return NotFound();
            }
            return Ok(user);
        }

        [HttpGet("email/{email}")]
        public async Task<ActionResult<User?>> GetByEmail(string email)
        {
            var user = await _userService.GetByEmailAsync(email);
            if (user == null)
            {
                return NotFound();
            }
            return Ok(user);
        }

        [HttpPost]
        public async Task<ActionResult<User>> CreateUser([FromBody] User user)
        {
            var createdUser = await _userService.CreateUserAsync(user);
            return CreatedAtAction(
                nameof(GetByFirebaseUid),
                new { firebaseUid = createdUser.FirebaseUid },
                createdUser
            );
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateUser(int id, [FromBody] User user)
        {
            if (id != user.ID)
            {
                return BadRequest();
            }

            await _userService.UpdateUserAsync(user);
            return NoContent();
        }

        [HttpPost("sync")]
        public async Task<ActionResult<User>> SyncUser([FromBody] UserSyncDto dto)
        {
            if (dto == null)
                return BadRequest("Body is null");

            var user = new User
            {
                FirebaseUid = dto.FirebaseUid,
                Username = dto.Username,
                Role = dto.Role,
                PhoneNumber = dto.PhoneNumber,
                LastName = dto.LastName,
                FirstName = dto.FirstName,
                Email = dto.Email,
                Sex = dto.Sex,
                Birthday = dto.Birthday ?? DateTime.MinValue,
                Address = dto.Address,
            };

            var createdUser = await _userService.CreateUserAsync(user);

            // Nếu user có role Admin, tự động đồng bộ sang AdminService
            if ((user.Role?.Trim().ToLower() ?? "") == "admin")
            {
                try
                {
                    var httpClient =
                        HttpContext.RequestServices.GetService(typeof(IHttpClientFactory))
                        as IHttpClientFactory;
                    var configuration =
                        HttpContext.RequestServices.GetService(typeof(IConfiguration))
                        as IConfiguration;
                    var adminServiceUrl =
                        configuration?["ServiceUrls:AdminService"]
                        ?? "http://adminservice:8081/api/admin";
                    var adminData = new
                    {
                        userId = createdUser.ID,
                        email = string.IsNullOrWhiteSpace(user.Email)
                            ? $"admin{createdUser.ID}@example.com"
                            : user.Email,
                        firstName = string.IsNullOrWhiteSpace(user.FirstName)
                            ? "Admin"
                            : user.FirstName,
                        lastName = string.IsNullOrWhiteSpace(user.LastName)
                            ? "User"
                            : user.LastName,
                        phoneNumber = string.IsNullOrWhiteSpace(user.PhoneNumber)
                            ? "0000000000"
                            : user.PhoneNumber,
                        sex = string.IsNullOrWhiteSpace(user.Sex) ? "Male" : user.Sex,
                        birthday = user.Birthday == DateTime.MinValue
                            ? DateTime.Now
                            : user.Birthday,
                        address = string.IsNullOrWhiteSpace(user.Address) ? "N/A" : user.Address,
                        password = "Admin@123",
                    };
                    var json = System.Text.Json.JsonSerializer.Serialize(adminData);
                    var content = new System.Net.Http.StringContent(
                        json,
                        System.Text.Encoding.UTF8,
                        "application/json"
                    );
                    var response = await httpClient
                        .CreateClient()
                        .PostAsync(adminServiceUrl, content);
                    if (!response.IsSuccessStatusCode)
                    {
                        var resp = await response.Content.ReadAsStringAsync();
                        Console.WriteLine($"[SyncUser] AdminService response: {resp}");
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"[SyncUser] Error: {ex.Message}");
                }
            }
            return CreatedAtAction(
                nameof(GetByFirebaseUid),
                new { firebaseUid = createdUser.FirebaseUid },
                createdUser
            );
        }

        [HttpPost("{id}/promote")]
        public async Task<IActionResult> PromoteUser(int id, [FromBody] PromoteUserDto dto)
        {
            var users = await _userService.GetAllAsync();
            var user = users.FirstOrDefault(u => u.ID == id);
            if (user == null)
                return NotFound();

            user.Role = dto.Role;
            await _userService.UpdateUserAsync(user);

            // Nếu role mới là Admin, đồng bộ sang AdminService
            if (dto.Role?.Trim().ToLower() == "admin")
            {
                try
                {
                    var httpClient =
                        HttpContext.RequestServices.GetService(typeof(IHttpClientFactory))
                        as IHttpClientFactory;
                    var configuration =
                        HttpContext.RequestServices.GetService(typeof(IConfiguration))
                        as IConfiguration;
                    var adminServiceUrl =
                        configuration["ServiceUrls:AdminService"]
                        ?? "http://adminservice:8081/api/admin";
                    var adminData = new
                    {
                        userId = user.ID,
                        email = string.IsNullOrWhiteSpace(user.Email)
                            ? $"admin{user.ID}@example.com"
                            : user.Email,
                        firstName = string.IsNullOrWhiteSpace(user.FirstName)
                            ? "Admin"
                            : user.FirstName,
                        lastName = string.IsNullOrWhiteSpace(user.LastName)
                            ? "User"
                            : user.LastName,
                        phoneNumber = string.IsNullOrWhiteSpace(user.PhoneNumber)
                            ? "0000000000"
                            : user.PhoneNumber,
                        sex = string.IsNullOrWhiteSpace(user.Sex) ? "Male" : user.Sex,
                        birthday = user.Birthday == DateTime.MinValue
                            ? DateTime.Now
                            : user.Birthday,
                        address = string.IsNullOrWhiteSpace(user.Address) ? "N/A" : user.Address,
                        password = "Admin@123",
                    };
                    var json = System.Text.Json.JsonSerializer.Serialize(adminData);
                    var content = new System.Net.Http.StringContent(
                        json,
                        System.Text.Encoding.UTF8,
                        "application/json"
                    );
                    var response = await httpClient
                        .CreateClient()
                        .PostAsync(adminServiceUrl, content);
                    if (!response.IsSuccessStatusCode)
                    {
                        var resp = await response.Content.ReadAsStringAsync();
                        Console.WriteLine($"[PromoteUser] AdminService response: {resp}");
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"[PromoteUser] Error: {ex.Message}");
                }
            }

            return Ok(user);
        }
    }
}
