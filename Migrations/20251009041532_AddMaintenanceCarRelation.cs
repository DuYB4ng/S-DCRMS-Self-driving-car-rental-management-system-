using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SDCRMS.Migrations
{
    /// <inheritdoc />
    public partial class AddMaintenanceCarRelation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Maintenances_Cars_CarID",
                table: "Maintenances");

            migrationBuilder.AlterColumn<int>(
                name: "CarID",
                table: "Maintenances",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Maintenances_Cars_CarID",
                table: "Maintenances",
                column: "CarID",
                principalTable: "Cars",
                principalColumn: "CarID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Maintenances_Cars_CarID",
                table: "Maintenances");

            migrationBuilder.AlterColumn<int>(
                name: "CarID",
                table: "Maintenances",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddForeignKey(
                name: "FK_Maintenances_Cars_CarID",
                table: "Maintenances",
                column: "CarID",
                principalTable: "Cars",
                principalColumn: "CarID");
        }
    }
}
