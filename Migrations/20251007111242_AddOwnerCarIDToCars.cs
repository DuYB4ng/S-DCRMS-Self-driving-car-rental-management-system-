using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SDCRMS.Migrations
{
    /// <inheritdoc />
    public partial class AddOwnerCarIDToCars : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Cars_OwnerCars_OwnerCarID",
                table: "Cars");

            migrationBuilder.AlterColumn<int>(
                name: "OwnerCarID",
                table: "Cars",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Cars_OwnerCars_OwnerCarID",
                table: "Cars",
                column: "OwnerCarID",
                principalTable: "OwnerCars",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Cars_OwnerCars_OwnerCarID",
                table: "Cars");

            migrationBuilder.AlterColumn<int>(
                name: "OwnerCarID",
                table: "Cars",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddForeignKey(
                name: "FK_Cars_OwnerCars_OwnerCarID",
                table: "Cars",
                column: "OwnerCarID",
                principalTable: "OwnerCars",
                principalColumn: "ID");
        }
    }
}
