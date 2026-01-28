namespace UserService.Dtos
{
    public class WalletTransactionDto
    {
        public string FirebaseUid { get; set; }
        public decimal Amount { get; set; }
    }

    public class UpdateBankDto
    {
        public string FirebaseUid { get; set; }
        public string BankAccountNumber { get; set; }
        public string BankName { get; set; }
    }
}
