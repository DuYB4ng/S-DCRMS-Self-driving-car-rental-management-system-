using System;

public class Users
{
    public int ID { get; set; } = 0;
    public int RoleID { get; set; } = 0;
    public int PhoneNumber { get; set; } = 0;
    public string LastName { get; set; } = string.Empty;
    public string FirstName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Sex { get; set; } = string.Empty;
    public DateTime Birthday { get; set; } = DateTime.UtcNow;
    public DateTime JoinDate { get; set; } = DateTime.Now;
}
