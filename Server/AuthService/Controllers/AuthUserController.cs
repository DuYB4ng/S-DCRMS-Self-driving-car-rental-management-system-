using Microsoft.AspNetCore.Mvc;
using AuthService.Repositories;
using AuthService.Models;
using AuthService.Dtos;
using FirebaseAdmin.Auth;

namespace AuthService.Services
{
    [ApiController]
    [Route("api/auth")]
    public class AuthUserController : ControllerBase
    {
        private readonly IAuthUserRepository _authUserRepository;
        private readonly FirebaseAuthService _firebaseAuthService;

        public AuthUserController(IAuthUserRepository authUserRepository, FirebaseAuthService firebaseAuthService)
        {
            _authUserRepository = authUserRepository;
            _firebaseAuthService = firebaseAuthService;
        }

        // Các endpoint cho đăng ký, đăng nhập, xác thực token, v.v.
        [HttpPost("signup")]
        public async Task<IActionResult> SignUp([FromBody] SignUpRequest request)
        {
            try
            {
                var firebaseUser = await _firebaseAuthService.CreateUserAsync(request.Email, request.Password, request.DisplayName);
                var existingUser = await _authUserRepository.GetByFirebaseUidAsync(firebaseUser.Uid);
                if (existingUser != null)
                {
                    return Conflict("User already exists.");
                }
                var authUser = new AuthUser
                {
                    FirebaseUid = firebaseUser.Uid,
                    Email = firebaseUser.Email,
                    DisplayName = firebaseUser.DisplayName,
                    Role = "Customer",
                    CreatedAt = DateTime.UtcNow
                };
                await _authUserRepository.AddAsync(authUser);
                return Ok(new { uid = firebaseUser.Uid, email = firebaseUser.Email });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPost("verifyToken")]
        public async Task<IActionResult> VerifyToken([FromBody] string idToken)
        {
            try
            {
                var uid = await _firebaseAuthService.VerifyIdTokenAsync(idToken);
                var user = await _authUserRepository.GetByFirebaseUidAsync(uid);
                if (user == null)
                {
                    return NotFound("User not found.");
                }
                return Ok(new { uid = user.FirebaseUid, email = user.Email, role = user.Role });
            }
            catch (Exception ex)
            {
                return Unauthorized(new { error = ex.Message });
            }
        }
    }
    public class TokenRequest
    {
        public string Token { get; set; } = string.Empty;
    }
}