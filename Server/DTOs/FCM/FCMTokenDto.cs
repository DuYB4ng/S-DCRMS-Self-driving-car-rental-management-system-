namespace SDCRMS.DTOs.FCM
{
    public class RegisterFCMTokenDto
    {
        public required string Token { get; set; }
        public required string DeviceType { get; set; } // "Android", "iOS", "Web"
    }

    public class FCMTokenDto
    {
        public int TokenID { get; set; }
        public int UserID { get; set; }
        public string Token { get; set; } = string.Empty;
        public string DeviceType { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
        public DateTime? LastUsedAt { get; set; }
        public bool IsActive { get; set; }
    }
}
