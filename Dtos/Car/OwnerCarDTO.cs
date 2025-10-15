namespace SDCRMS.Dtos.Car
{
    public class OwnerCarDTO
    {
        public int OwnerCarID { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;
        public string Address { get; set; } = string.Empty;

        public List<CarDTO>? Cars { get; set; } = new List<CarDTO>();
    }
}