namespace OwnerCarService.Dtos.Car
{
    public class UpdateMaintenanceDTO
    {
        public DateTime MaintenanceDate { get; set; }
        public string Description { get; set; } = string.Empty;
        public decimal Cost { get; set; }
        public bool Status { get; set; } // 2 trạng thái : True : cần bảo  trì, False : đã bảo trì xong

        public int CarID { get; set; }
    }
}