import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import '../services/wallet_service.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> with WidgetsBindingObserver {
  final WalletService _walletService = WalletService();
  double _balance = 0;
  String? _bankName;
  String? _bankAccountNumber;
  bool _isLoading = true;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadWalletInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _amountController.dispose();
    _bankNameController.dispose();
    _bankAccountController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadWalletInfo();
    }
  }

  Future<void> _loadWalletInfo() async {
    setState(() => _isLoading = true);
    try {
      final res = await _walletService.getBalance();
      final data = res.data;
      setState(() {
        _balance = (data['balance'] ?? data['Balance'] ?? 0).toDouble();
        _bankName = data['bankName'] ?? data['BankName'];
        _bankAccountNumber = data['bankAccountNumber'] ?? data['BankAccountNumber'];
        
        if (_bankName != null) _bankNameController.text = _bankName!;
        if (_bankAccountNumber != null) _bankAccountController.text = _bankAccountNumber!;
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading wallet: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateBankInfo() async {
    try {
      await _walletService.updateBankInfo(_bankNameController.text, _bankAccountController.text);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bank info updated')));
      _loadWalletInfo();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating bank info: $e')));
    }
  }

  Future<void> _topUpVnPay() async {
    final amount = double.tryParse(_amountController.text.replaceAll('.', '').replaceAll(',', ''));
    if (amount == null || amount <= 0) return;
    
    try {
      final res = await _walletService.topUpVnPay(amount);
      if (mounted) {
        final data = res.data;
        if (data != null && data['paymentUrl'] != null) {
           final url = Uri.parse(data['paymentUrl']);
           print("Opening Payment URL: $url");
           
           if (await canLaunchUrl(url)) {
             await launchUrl(url, mode: LaunchMode.externalApplication);
             if (mounted) {
                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đang chuyển hướng sang VNPAY...')));
             }
           } else {
             print("Could not launch $url");
             // Force try launch anyway (sometimes canLaunchUrl Check returns false on some Android versions but launch works)
             try {
                await launchUrl(url, mode: LaunchMode.externalApplication);
                if (mounted) Navigator.pop(context);
             } catch (e) {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Không thể mở liên kết: $url')));
             }
           }
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi tạo thanh toán VNPay: $e')));
    }
  }

  void _showTopUpDialog() {
    _amountController.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nạp tiền qua VNPay"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Nhập số tiền muốn nạp (tối thiểu 10.000 VNĐ):"),
             const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: "Nhập số tiền (VNĐ)", suffixText: "đ"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(onPressed: _topUpVnPay, child: const Text("Thanh toán ngay")),
        ],
      )
    );
  }

  void _showWithdrawDialog() {
    _amountController.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Rút tiền"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_bankName == null || _bankAccountNumber == null)
               const Text("LƯU Ý: Vui lòng cập nhật thông tin ngân hàng bên dưới trước khi rút tiền!", style: TextStyle(color: Colors.red)),
            const Text("Tiền sẽ được chuyển về tài khoản ngân hàng đã đăng ký trong vòng 24h."),
             const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: "Nhập số tiền muốn rút"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(
            onPressed: (_bankName == null || _bankAccountNumber == null) ? null : _withdraw, 
            child: const Text("Xác nhận")
          ),
        ],
      )
    );
  }

  Future<void> _withdraw() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return;
    
    try {
      final res = await _walletService.withdraw(amount);
      if (mounted) {
        // Backend returns JSON with Message
        final msg = res.data['Message'] ?? "Yêu cầu rút tiền thành công";
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        Navigator.pop(context); // Close dialog
      }
      _loadWalletInfo();
    } catch (e) {
      String err = e.toString();
      if (e is DioException) {
         err = e.response?.data?['Message'] ?? e.message;
      }
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi rút tiền: $err')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ví của tôi")),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Balance Card
                Card(
                  color: Colors.blueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text("Số dư khả dụng", style: TextStyle(color: Colors.white, fontSize: 16)),
                        const SizedBox(height: 10),
                        Text(
                          "${_balance.toInt().toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')} VNĐ", 
                          style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _showTopUpDialog,
                              icon: const Icon(Icons.add),
                              label: const Text("Nạp tiền"),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.blueAccent),
                            ),
                            ElevatedButton.icon(
                              onPressed: _showWithdrawDialog,
                              icon: const Icon(Icons.arrow_downward),
                              label: const Text("Rút tiền"),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text("Thông tin ngân hàng (để rút tiền)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextField(
                  controller: _bankNameController,
                  decoration: const InputDecoration(labelText: "Tên ngân hàng", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _bankAccountController,
                  decoration: const InputDecoration(labelText: "Số tài khoản", border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateBankInfo,
                    child: const Text("Cập nhật thông tin ngân hàng"),
                  ),
                )
              ],
            ),
          ),
    );
  }
}
