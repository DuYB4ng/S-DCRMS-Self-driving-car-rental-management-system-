using OwnerCarService.Dtos.Car;

namespace OwnerCarService.Dtos.Car
{
    public class MaintenanceDTO
    {
        public int MaintenanceID { get; set; }
        public DateTime MaintenanceDate { get; set; }
        public string Description { get; set; } = string.Empty;
        public decimal Cost { get; set; }
        public bool Status { get; set; } // 2 trạng thái : True : cần bảo  trì, False : đã bảo trì xong

        public int CarID { get; set; }
        public CarDTO? Car { get; set; }
    }
}