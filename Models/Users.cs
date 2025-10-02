namespace SDCRMS.Models
{
    public abstract class Users
    {
        public int ID { get; set; }
        public int RoleID { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public int PhoneNumber { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public string Email { get; set; }
        public string Sex { get; set; }
        public DateTime Birthday { get; set; }
        public DateTime JoinDate { get; set; } = DateTime.Now;
        public string Address { get; set; }
        public List<Notification> Notifications { get; set; } = new List<Notification>();
    }
}