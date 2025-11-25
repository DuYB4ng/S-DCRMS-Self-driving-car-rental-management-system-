namespace UserService.Controllers
{
    using Microsoft.AspNetCore.Mvc;
    using UserService.Models;
    using UserService.Services;

    [ApiController]
    [Route("api/users")]
    public class UserController : ControllerBase
    {
        private readonly IUserService _userService;

        public UserController(IUserService userService)
        {
            _userService = userService;
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
            return CreatedAtAction(
                nameof(GetByFirebaseUid),
                new { firebaseUid = createdUser.FirebaseUid },
                createdUser
            );
        }
    }
}
