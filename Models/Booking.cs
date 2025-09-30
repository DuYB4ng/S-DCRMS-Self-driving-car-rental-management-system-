using System;

public class Booking
{
	public int BookingID { get; set; }
	public int CustomerID { get; set; }
	public int CarID { get; set; }
	public DateTime StartDate { get; set; }
	public DateTime EndDate { get; set; }
	public bool CheckIn { get; set; }
	public bool CheckOut { get; set; }
}
