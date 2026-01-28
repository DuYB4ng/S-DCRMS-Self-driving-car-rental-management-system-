import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'api_service.dart';

class WalletService {
  final ApiService api = ApiService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Response> getBalance() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Not logged in");
    return await api.get("/wallet/balance", queryParameters: {"firebaseUid": user.uid});
  }

  Future<Response> topUp(double amount) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Not logged in");
    return await api.post("/wallet/topup", {
      "firebaseUid": user.uid,
      "amount": amount
    });
  }

  Future<Response> topUpVnPay(double amount) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Not logged in");
    return await api.post("/wallet/topup-vnpay", {
      "firebaseUid": user.uid,
      "amount": amount
    });
  }

  Future<Response> updateBankInfo(String bankName, String bankAccount) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Not logged in");
    return await api.post("/wallet/update-bank", {
      "firebaseUid": user.uid,
      "bankName": bankName,
      "bankAccountNumber": bankAccount
    });
  }

  Future<Response> withdraw(double amount) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Not logged in");
    return await api.post("/wallet/withdraw", {
      "firebaseUid": user.uid,
      "amount": amount
    });
  }
}
