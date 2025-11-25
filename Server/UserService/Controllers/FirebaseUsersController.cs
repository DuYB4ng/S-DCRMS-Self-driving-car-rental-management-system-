using System.Collections.Generic;
using System.Threading.Tasks;
using FirebaseAdmin;
using FirebaseAdmin.Auth;
using Google.Apis.Auth.OAuth2;
using Microsoft.AspNetCore.Mvc;

namespace UserService.Controllers
{
    [ApiController]
    [Route("api/firebase-users")]
    public class FirebaseUsersController : ControllerBase
    {
        private static bool _firebaseInitialized = false;

        public FirebaseUsersController()
        {
            if (!_firebaseInitialized)
            {
                FirebaseApp.Create(
                    new AppOptions
                    {
                        Credential = GoogleCredential.FromStream(
                            System.IO.File.OpenRead("FireBase/FireBaseToken.json")
                        ),
                    }
                );
                _firebaseInitialized = true;
            }
        }

        [HttpGet]
        public async Task<ActionResult<List<ExportedUserRecord>>> GetAllFirebaseUsers()
        {
            var users = new List<ExportedUserRecord>();
            var pagedEnumerable = FirebaseAuth.DefaultInstance.ListUsersAsync(null);
            await foreach (var user in pagedEnumerable)
            {
                users.Add(user);
            }
            return Ok(users);
        }
    }
}
