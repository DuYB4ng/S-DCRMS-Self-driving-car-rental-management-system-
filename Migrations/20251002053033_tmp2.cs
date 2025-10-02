using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SDCRMS.Migrations
{
    /// <inheritdoc />
    public partial class tmp2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "DrivingLisence",
                table: "Customers",
                newName: "DrivingLicense");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "DrivingLicense",
                table: "Customers",
                newName: "DrivingLisence");
        }
    }
}
