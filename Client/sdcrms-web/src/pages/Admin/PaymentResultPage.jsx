import { useLocation } from "react-router-dom";

export default function PaymentResultPage() {
  const location = useLocation();
  const params = new URLSearchParams(location.search);

  const responseCode = params.get("vnp_ResponseCode");
  const txnRef = params.get("vnp_TxnRef");
  const amount = params.get("vnp_Amount");
  const transactionNo = params.get("vnp_TransactionNo");

  const isSuccess = responseCode === "00";

  return (
    <div style={{ padding: 24 }}>
      <h1>Kết quả thanh toán VNPay</h1>
      <p>Mã giao dịch (TxnRef): <b>{txnRef}</b></p>
      <p>Mã giao dịch VNPay: <b>{transactionNo}</b></p>
      <p>Số tiền: <b>{amount}</b></p>
      <p>
        Trạng thái:{" "}
        <b style={{ color: isSuccess ? "green" : "red" }}>
          {isSuccess ? "THÀNH CÔNG" : `THẤT BẠI (code = ${responseCode})`}
        </b>
      </p>
      <p style={{ marginTop: 16 }}>
        Bạn có thể quay lại ứng dụng để tiếp tục.
      </p>
    </div>
  );
}
