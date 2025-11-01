using System.Collections.Generic;
using SDCRMS.Models.Enums;
namespace SDCRMS.Models
{
    public class OwnerCar : Users
    {
        public OwnerCar() => Role = UserRole.Owner;
        public List<Car> Cars { get; set; } = new List<Car>();
    }
}
