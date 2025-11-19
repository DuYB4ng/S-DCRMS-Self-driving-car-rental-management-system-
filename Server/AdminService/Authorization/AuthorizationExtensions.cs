using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using SDCRMS.Models.Enums;

namespace SDCRMS.Authorization
{
    public static class RoleNames
    {
        public const string Admin = nameof(UserRole.Admin);
        public const string Staff = nameof(UserRole.Staff);
        public const string Customer = nameof(UserRole.Customer);
    }

    public static class AuthorizationPolicies
    {
        public const string AdminOnly = "AdminOnly";
        public const string StaffOrAdmin = "StaffOrAdmin";
        public const string AuthenticatedUser = "AuthenticatedUser";
    }

    public static class AuthorizationServiceCollectionExtensions
    {
        public static IServiceCollection AddRoleBasedAuthorization(this IServiceCollection services)
        {
            services.AddAuthorization(options =>
            {
                options.DefaultPolicy = new AuthorizationPolicyBuilder(
                    JwtBearerDefaults.AuthenticationScheme
                )
                    .RequireAuthenticatedUser()
                    .Build();

                options.AddPolicy(
                    AuthorizationPolicies.AdminOnly,
                    policy => policy.RequireRole(RoleNames.Admin)
                );

                options.AddPolicy(
                    AuthorizationPolicies.StaffOrAdmin,
                    policy => policy.RequireRole(RoleNames.Admin, RoleNames.Staff)
                );

                options.AddPolicy(
                    AuthorizationPolicies.AuthenticatedUser,
                    policy =>
                        policy.RequireRole(RoleNames.Admin, RoleNames.Staff, RoleNames.Customer)
                );
            });

            return services;
        }
    }
}
