using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OwnerCarService.Models
{
    public class CarCalendar
    {
        [Key]
        public int Id { get; set; }

        public int CarId { get; set; }

        [ForeignKey("CarId")]
        public Car Car { get; set; }

        public DateTime Date { get; set; }

        // Status: "Available", "Busy" (Owner blocked), "Booked" (System blocked)
        public string Status { get; set; } = "Busy"; 

        public decimal? PrivatePrice { get; set; } // Optional: Custom price for this day
    }
}
