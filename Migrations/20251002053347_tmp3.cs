using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SDCRMS.Migrations
{
    /// <inheritdoc />
    public partial class tmp3 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "LisenceIssueDate",
                table: "Customers",
                newName: "LicenseIssueDate");

            migrationBuilder.RenameColumn(
                name: "LisenceExpiryDate",
                table: "Customers",
                newName: "LicenseExpiryDate");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "LicenseIssueDate",
                table: "Customers",
                newName: "LisenceIssueDate");

            migrationBuilder.RenameColumn(
                name: "LicenseExpiryDate",
                table: "Customers",
                newName: "LisenceExpiryDate");
        }
    }
}
