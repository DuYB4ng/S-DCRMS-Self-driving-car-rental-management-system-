namespace SDCRMS.Models
{
    public class OwnerCar : Users
    {
        public List<Car> Cars { get; set; } = new List<Car>();
    }
}
