import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../../models/payment.dart';

class ThirdPartyPaymentScreen extends StatefulWidget {
  const ThirdPartyPaymentScreen({super.key});

  @override
  State<ThirdPartyPaymentScreen> createState() =>
      _ThirdPartyPaymentScreenState();
}

class _ThirdPartyPaymentScreenState extends State<ThirdPartyPaymentScreen> {
  String selectedFilter = 'Tất cả';

  // Dữ liệu mẫu
  List<Payment> payments = [
    Payment(
      id: 'PAY001',
      bookingId: 'BK001',
      customerName: 'Nguyễn Văn A',
      amount: 1500000,
      method: 'momo',
      status: 'completed',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      completedAt: DateTime.now().subtract(
        const Duration(hours: 1, minutes: 55),
      ),
      transactionId: 'MOMO123456789',
    ),
    Payment(
      id: 'PAY002',
      bookingId: 'BK002',
      customerName: 'Trần Thị B',
      amount: 4500000,
      method: 'vnpay',
      status: 'processing',
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      transactionId: 'VNPAY987654321',
    ),
    Payment(
      id: 'PAY003',
      bookingId: 'BK003',
      customerName: 'Lê Văn C',
      amount: 900000,
      method: 'zalopay',
      status: 'pending',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Payment(
      id: 'PAY004',
      bookingId: 'BK004',
      customerName: 'Phạm Thị D',
      amount: 2000000,
      method: 'bank_transfer',
      status: 'completed',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      completedAt: DateTime.now().subtract(const Duration(days: 1, hours: -2)),
      transactionId: 'BANK202411170001',
    ),
  ];

  List<Payment> get filteredPayments {
    if (selectedFilter == 'Tất cả') {
      return payments;
    } else if (selectedFilter == 'Chờ xử lý') {
      return payments.where((p) => p.status == 'pending').toList();
    } else if (selectedFilter == 'Đang xử lý') {
      return payments.where((p) => p.status == 'processing').toList();
    } else if (selectedFilter == 'Thành công') {
      return payments.where((p) => p.status == 'completed').toList();
    } else if (selectedFilter == 'Thất bại') {
      return payments.where((p) => p.status == 'failed').toList();
    }
    return payments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thanh toán bên thứ ba',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          _buildStatsBar(),
          _buildPaymentMethods(),
          Expanded(child: _buildPaymentList()),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      'Tất cả',
      'Chờ xử lý',
      'Đang xử lý',
      'Thành công',
      'Thất bại',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: 8,
      ),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = filter == selectedFilter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
                selectedColor: primaryColor,
                backgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? primaryColor : Colors.grey[300]!,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    final total = payments.fold<double>(0, (sum, p) => sum + p.amount);
    final completed = payments
        .where((p) => p.status == 'completed')
        .fold<double>(0, (sum, p) => sum + p.amount);
    final pending = payments
        .where((p) => p.status == 'pending' || p.status == 'processing')
        .fold<double>(0, (sum, p) => sum + p.amount);

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      color: Colors.white,
      child: Row(
        children: [
          _buildStatItem('Tổng', total, primaryColor),
          _buildStatItem('Thành công', completed, successColor),
          _buildStatItem('Chờ xử lý', pending, warningColor),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, double amount, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '${NumberFormat('#,###').format(amount)}đ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: textSecondaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      color: cardBgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phương thức thanh toán',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildMethodCard(
                  'MoMo',
                  'assets/icons/momo.png',
                  const Color(0xFFD82D8B),
                ),
                _buildMethodCard(
                  'VNPay',
                  'assets/icons/vnpay.png',
                  const Color(0xFF005BAA),
                ),
                _buildMethodCard(
                  'ZaloPay',
                  'assets/icons/zalopay.png',
                  const Color(0xFF008FE5),
                ),
                _buildMethodCard(
                  'Ngân hàng',
                  null,
                  successColor,
                  icon: Icons.account_balance,
                ),
                _buildMethodCard(
                  'Tiền mặt',
                  null,
                  warningColor,
                  icon: Icons.payments,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodCard(
    String name,
    String? imagePath,
    Color color, {
    IconData? icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: icon != null
                ? Icon(icon, color: color, size: 28)
                : const Icon(Icons.payment, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentList() {
    if (filteredPayments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Không có giao dịch nào',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(defaultPadding),
      itemCount: filteredPayments.length,
      itemBuilder: (context, index) {
        return _buildPaymentCard(filteredPayments[index]);
      },
    );
  }

  Widget _buildPaymentCard(Payment payment) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (payment.status) {
      case 'pending':
        statusColor = warningColor;
        statusText = 'Chờ xử lý';
        statusIcon = Icons.pending;
        break;
      case 'processing':
        statusColor = accentColor;
        statusText = 'Đang xử lý';
        statusIcon = Icons.sync;
        break;
      case 'completed':
        statusColor = successColor;
        statusText = 'Thành công';
        statusIcon = Icons.check_circle;
        break;
      case 'failed':
        statusColor = dangerColor;
        statusText = 'Thất bại';
        statusIcon = Icons.error;
        break;
      case 'refunded':
        statusColor = textSecondaryColor;
        statusText = 'Đã hoàn tiền';
        statusIcon = Icons.undo;
        break;
      default:
        statusColor = textSecondaryColor;
        statusText = payment.status;
        statusIcon = Icons.help;
    }

    IconData methodIcon;
    Color methodColor;
    String methodName;

    switch (payment.method) {
      case 'momo':
        methodIcon = Icons.account_balance_wallet;
        methodColor = const Color(0xFFD82D8B);
        methodName = 'MoMo';
        break;
      case 'vnpay':
        methodIcon = Icons.credit_card;
        methodColor = const Color(0xFF005BAA);
        methodName = 'VNPay';
        break;
      case 'zalopay':
        methodIcon = Icons.account_balance_wallet;
        methodColor = const Color(0xFF008FE5);
        methodName = 'ZaloPay';
        break;
      case 'bank_transfer':
        methodIcon = Icons.account_balance;
        methodColor = successColor;
        methodName = 'Chuyển khoản';
        break;
      case 'cash':
        methodIcon = Icons.payments;
        methodColor = warningColor;
        methodName = 'Tiền mặt';
        break;
      default:
        methodIcon = Icons.payment;
        methodColor = textSecondaryColor;
        methodName = payment.method;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: defaultPadding),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _viewPaymentDetail(payment),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: methodColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(methodIcon, color: methodColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payment.id,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          methodName,
                          style: TextStyle(
                            fontSize: 13,
                            color: methodColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: textSecondaryColor),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      payment.customerName,
                      style: const TextStyle(fontSize: 14, color: textColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.receipt,
                    size: 16,
                    color: textSecondaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Đơn hàng: ${payment.bookingId}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: textSecondaryColor,
                    ),
                  ),
                ],
              ),
              if (payment.transactionId != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.tag, size: 16, color: textSecondaryColor),
                    const SizedBox(width: 6),
                    Text(
                      'MGD: ${payment.transactionId}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${NumberFormat('#,###').format(payment.amount)}đ',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(payment.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewPaymentDetail(Payment payment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Chi tiết thanh toán',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow('Mã thanh toán', payment.id),
                    _buildDetailRow('Mã đơn hàng', payment.bookingId),
                    _buildDetailRow('Khách hàng', payment.customerName),
                    _buildDetailRow(
                      'Số tiền',
                      '${NumberFormat('#,###').format(payment.amount)}đ',
                    ),
                    _buildDetailRow('Phương thức', payment.method),
                    _buildDetailRow('Trạng thái', payment.status),
                    if (payment.transactionId != null)
                      _buildDetailRow('Mã giao dịch', payment.transactionId!),
                    _buildDetailRow(
                      'Thời gian tạo',
                      DateFormat(
                        'dd/MM/yyyy HH:mm:ss',
                      ).format(payment.createdAt),
                    ),
                    if (payment.completedAt != null)
                      _buildDetailRow(
                        'Thời gian hoàn thành',
                        DateFormat(
                          'dd/MM/yyyy HH:mm:ss',
                        ).format(payment.completedAt!),
                      ),
                    if (payment.notes != null)
                      _buildDetailRow('Ghi chú', payment.notes!),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Đóng'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: textSecondaryColor),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
