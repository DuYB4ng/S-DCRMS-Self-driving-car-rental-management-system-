using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using BookingService.Models;

namespace BookingService.Services
{
    public class VNPayService
    {
        private readonly IConfiguration _configuration;

        public VNPayService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        // Tạo URL thanh toán VNPay cho 1 payment
        public string CreatePaymentUrl(Payment payment, HttpContext httpContext)
        {
            var vnp_Url = _configuration["VNPay:PaymentUrl"];
            var vnp_Returnurl = _configuration["VNPay:ReturnUrl"];
            var vnp_TmnCode = _configuration["VNPay:TmnCode"];
            var vnp_HashSecret = _configuration["VNPay:HashSecret"];

            var vnp_Params = new SortedList<string, string>();

            vnp_Params["vnp_Version"] = "2.1.0";
            vnp_Params["vnp_Command"] = "pay";
            vnp_Params["vnp_TmnCode"] = vnp_TmnCode;
            vnp_Params["vnp_Amount"] = ((long)(payment.Amount * 100)).ToString(); // VNPay yêu cầu *100
            vnp_Params["vnp_CreateDate"] = DateTime.Now.ToString("yyyyMMddHHmmss");
            vnp_Params["vnp_CurrCode"] = "VND";
            vnp_Params["vnp_IpAddr"] = GetIpAddress(httpContext);
            vnp_Params["vnp_Locale"] = "vn";
            vnp_Params["vnp_OrderInfo"] = $"Thanh toan booking {payment.BookingID}";
            vnp_Params["vnp_OrderType"] = "other";
            vnp_Params["vnp_ReturnUrl"] = vnp_Returnurl;
            vnp_Params["vnp_TxnRef"] = payment.PaymentID.ToString();
            vnp_Params["vnp_ExpireDate"] = DateTime.Now.AddMinutes(15).ToString("yyyyMMddHHmmss");

            var queryString = BuildQueryString(vnp_Params, vnp_HashSecret);

            return $"{vnp_Url}?{queryString}";
        }

        // Xử lý & xác thực IPN
        public VNPayIpnResult ValidateIpn(IQueryCollection query)
        {
            var result = new VNPayIpnResult
            {
                RspCode = "97",
                Message = "Invalid signature"
            };

            var vnp_HashSecret = _configuration["VNPay:HashSecret"];
            var vnpData = new SortedList<string, string>();

            string vnp_SecureHash = query["vnp_SecureHash"];

            foreach (var key in query.Keys)
            {
                var value = query[key].ToString();
                if (!string.IsNullOrEmpty(key) &&
                    !string.IsNullOrEmpty(value) &&
                    key != "vnp_SecureHash" &&
                    key != "vnp_SecureHashType")
                {
                    vnpData.Add(key, value);
                }
            }

            var rawData = string.Join("&", vnpData.Select(kvp => kvp.Key + "=" + kvp.Value));
            var myChecksum = HmacSHA512(vnp_HashSecret, rawData);

            if (!string.Equals(myChecksum, vnp_SecureHash, StringComparison.OrdinalIgnoreCase))
            {
                return result; // sai chữ ký
            }

            // chữ ký OK
            result.RspCode = "00";
            result.Message = "Confirm Success";

            vnpData.TryGetValue("vnp_TxnRef", out var orderId);
            vnpData.TryGetValue("vnp_Amount", out var amountStr);
            vnpData.TryGetValue("vnp_ResponseCode", out var responseCode);
            vnpData.TryGetValue("vnp_TransactionStatus", out var transactionStatus);
            vnpData.TryGetValue("vnp_TransactionNo", out var transactionNo);

            result.OrderId = orderId;
            if (long.TryParse(amountStr, out var amt))
                result.Amount = amt;
            result.ResponseCode = responseCode;
            result.TransactionStatus = transactionStatus;
            result.TransactionNo = transactionNo;

            return result;
        }

        private static string GetIpAddress(HttpContext context)
        {
            var ip = context.Connection.RemoteIpAddress?.ToString();
            if (string.IsNullOrEmpty(ip))
            {
                ip = "127.0.0.1";
            }
            return ip;
        }

        private static string BuildQueryString(SortedList<string, string> vnpParams, string hashSecret)
        {
            var rawData = string.Join("&", vnpParams.Select(kvp => kvp.Key + "=" + kvp.Value));
            var secureHash = HmacSHA512(hashSecret, rawData);

            var query = string.Join("&",
                vnpParams.Select(kvp => Uri.EscapeDataString(kvp.Key) + "=" + Uri.EscapeDataString(kvp.Value)));

            return $"{query}&vnp_SecureHash={secureHash}";
        }

        private static string HmacSHA512(string key, string input)
        {
            var keyBytes = Encoding.UTF8.GetBytes(key);
            var inputBytes = Encoding.UTF8.GetBytes(input);

            using var hmac = new HMACSHA512(keyBytes);
            var hashBytes = hmac.ComputeHash(inputBytes);

            var sb = new StringBuilder();
            foreach (var b in hashBytes)
            {
                sb.Append(b.ToString("x2"));
            }
            return sb.ToString();
        }
    }

    public class VNPayIpnResult
    {
        public string RspCode { get; set; } = "00";
        public string Message { get; set; } = "OK";
        public string? OrderId { get; set; }
        public long Amount { get; set; }
        public string? ResponseCode { get; set; }
        public string? TransactionStatus { get; set; }
        public string? TransactionNo { get; set; }
    }
}
