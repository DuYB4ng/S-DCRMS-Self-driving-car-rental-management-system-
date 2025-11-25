using SDCRMS.Models.Enums;

namespace SDCRMS.Models
{
    public abstract class Users
    {
        public int UserID { get; set; }
        public UserRole Role { get; set; }

        [System.ComponentModel.DataAnnotations.Schema.Column(TypeName = "longtext")]
        public string PhoneNumber { get; set; } = string.Empty;

        [System.ComponentModel.DataAnnotations.Schema.Column(TypeName = "longtext")]
        public string LastName { get; set; } = string.Empty;

        [System.ComponentModel.DataAnnotations.Schema.Column(TypeName = "longtext")]
        public string FirstName { get; set; } = string.Empty;

        [System.ComponentModel.DataAnnotations.Schema.Column(TypeName = "varchar(191)")]
        [System.ComponentModel.DataAnnotations.MaxLength(191)]
        public string Email { get; set; } = string.Empty;

        [System.ComponentModel.DataAnnotations.Schema.Column(TypeName = "longtext")]
        public string Password { get; set; } = string.Empty;

        [System.ComponentModel.DataAnnotations.Schema.Column(TypeName = "longtext")]
        public string Sex { get; set; } = string.Empty;
        public DateTime Birthday { get; set; }
        public DateTime JoinDate { get; set; }

        [System.ComponentModel.DataAnnotations.Schema.Column(TypeName = "longtext")]
        public string Address { get; set; } = string.Empty;
    }
}
