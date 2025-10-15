using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SDCRMS.Migrations
{
    /// <inheritdoc />
    public partial class Init1 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "RoleID",
                table: "Staffs",
                newName: "Role");

            migrationBuilder.RenameColumn(
                name: "RoleID",
                table: "OwnerCars",
                newName: "Role");

            migrationBuilder.RenameColumn(
                name: "RoleID",
                table: "Customers",
                newName: "Role");

            migrationBuilder.RenameColumn(
                name: "RoleID",
                table: "Admins",
                newName: "Role");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Role",
                table: "Staffs",
                newName: "RoleID");

            migrationBuilder.RenameColumn(
                name: "Role",
                table: "OwnerCars",
                newName: "RoleID");

            migrationBuilder.RenameColumn(
                name: "Role",
                table: "Customers",
                newName: "RoleID");

            migrationBuilder.RenameColumn(
                name: "Role",
                table: "Admins",
                newName: "RoleID");
        }
    }
}
