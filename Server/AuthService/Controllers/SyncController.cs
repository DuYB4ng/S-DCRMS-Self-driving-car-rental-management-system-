using Microsoft.AspNetCore.Mvc;
using AuthService.Repositories;
using AuthService.Models;
using AuthService.Services;

namespace AuthService.Controllers
{
    [ApiController]
    [Route("api/auth/sync")]
    public class SyncController : ControllerBase
    {
        private readonly IAuthUserRepository _authRepo;
        private readonly FirebaseAuthService _firebaseService;

        public SyncController(IAuthUserRepository authRepo, FirebaseAuthService firebaseService)
        {
            _authRepo = authRepo;
            _firebaseService = firebaseService;
        }

        // 🔄 Sync Firebase Users -> AuthDB
        // Logic:
        // 1. Get all users from Firebase
        // 2. Get all users from AuthDB
        // 3. If in Firebase but not in DB -> Add to DB (Default Role: Customer)
        // 4. If in DB but not in Firebase -> Delete from DB
        [HttpPost]
        public async Task<IActionResult> SyncUsers()
        {
            try
            {
                // 1. Fetch Data
                var firebaseUsers = await _firebaseService.GetAllUsersAsync();
                var dbUsers = await _authRepo.GetAllAsync();

                int addedCount = 0;
                int deletedCount = 0;

                var firebaseUids = firebaseUsers.Select(u => u.Uid).ToHashSet();
                var dbUids = dbUsers.Select(u => u.FirebaseUid).ToHashSet();

                // 2. Add Missing Users (Firebase -> DB)
                foreach (var fbUser in firebaseUsers)
                {
                    if (!dbUids.Contains(fbUser.Uid))
                    {
                        var newUser = new AuthUser
                        {
                            FirebaseUid = fbUser.Uid,
                            Email = fbUser.Email ?? "",
                            DisplayName = fbUser.DisplayName ?? "No Name",
                            Role = "Customer", // ⚠️ Default role because we don't know it from Firebase
                            CreatedAt = DateTime.UtcNow
                        };
                        await _authRepo.AddAsync(newUser);
                        addedCount++;
                    }
                }

                // 3. Delete Orphan Users (DB -> Firebase)
                foreach (var dbUser in dbUsers)
                {
                    if (!firebaseUids.Contains(dbUser.FirebaseUid))
                    {
                        await _authRepo.DeleteAsync(dbUser);
                        deletedCount++;
                    }
                }

                return Ok(new
                {
                    message = "Sync completed successfully.",
                    stats = new
                    {
                        firebaseTotal = firebaseUsers.Count,
                        dbTotal = dbUsers.Count,
                        added = addedCount,
                        deleted = deletedCount
                    }
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }
    }
}
