using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UserService.Models
{
    public class User
    {
        public int ID { get; set; }

        [Required]
        public string FirebaseUid { get; set; }

        [MaxLength(100)]
        public string Username { get; set; }
        public string Role { get; set; }
        public string PhoneNumber { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public string Email { get; set; }
        public string Sex { get; set; }
        public DateTime Birthday { get; set; }
        public DateTime JoinDate { get; set; } = DateTime.Now;
        public string Address { get; set; }
    }
}
