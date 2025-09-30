namespace SDCRMS.Models
{
    public class Maintenance
    {
        public int MaintenanceID { get; set; }
        public int CarID { get; set; }
        public DateTime MaintenanceDate { get; set; }
        public string Description { get; set; }
        public decimal Cost { get; set; }
        public bool Status { get; set; } // 2 trạng thái : True : cần bảo  trì, False : đã bảo trì xong
    }
}
