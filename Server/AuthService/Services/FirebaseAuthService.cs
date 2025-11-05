using FirebaseAdmin;
using FirebaseAdmin.Auth;
using FirebaseAdmin.Auth.Hash;
namespace AuthService.Services
{
    public class FirebaseAuthService
    {
        private readonly FirebaseAuth _auth;

        public FirebaseAuthService()
        {
            if (FirebaseApp.DefaultInstance == null)
            {
                FirebaseApp.Create(new AppOptions()
                {
                    Credential = Google.Apis.Auth.OAuth2.GoogleCredential.FromFile("firebase-adminsdk.json")
                });
            }
            _auth = FirebaseAuth.GetAuth(FirebaseApp.DefaultInstance);
        }

        public async Task<UserRecord> CreateUserAsync(string email, string password, string displayName = null)
        {
            var args = new UserRecordArgs()
            {
                Email = email,
                Password = password,
                DisplayName = displayName
            };
            return await _auth.CreateUserAsync(args);
        }

        public async Task<UserRecord> GetUserByUidAsync(string uid)
        {
            return await _auth.GetUserAsync(uid);
        }

        public async Task DeleteUserAsync(string uid)
        {
            await _auth.DeleteUserAsync(uid);
        }

        public async Task<string> VerifyIdTokenAsync(string idToken)
        {
            var decodedToken = await _auth.VerifyIdTokenAsync(idToken);
            return decodedToken.Uid;
        }
    }
}