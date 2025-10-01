using System;

public class Users
{
    public int ID { get; set; } = 0;
    public int RoleID { get; set; } = 0;
    public required int PhoneNumber { get; set; }
    public required string LastName { get; set; }
    public required string FirstName { get; set; }
    public required string Email { get; set; }
    public required string Sex { get; set; }
    public DateTime Birthday { get; set; }
    public DateTime JoinDate { get; set; }
}
