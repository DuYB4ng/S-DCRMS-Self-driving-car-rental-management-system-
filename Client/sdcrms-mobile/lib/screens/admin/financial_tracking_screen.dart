import 'package:flutter/material.dart';
import '../../constants.dart';

class FinancialTrackingScreen extends StatefulWidget {
  const FinancialTrackingScreen({super.key});

  @override
  State<FinancialTrackingScreen> createState() =>
      _FinancialTrackingScreenState();
}

class _FinancialTrackingScreenState extends State<FinancialTrackingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: successColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Theo dõi giao dịch tài chính',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Giao dịch'),
            Tab(text: 'Thu chi'),
            Tab(text: 'Tuân thủ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTransactionsTab(),
          _buildRevenueExpenseTab(),
          _buildComplianceTab(),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab() {
    final transactions = [
      {
        'id': '#TXN001',
        'customer': 'Nguyễn Văn A',
        'amount': '2,500,000',
        'status': 'Thành công',
        'method': 'VNPay',
        'time': '10:30 - 16/11/2025',
      },
      {
        'id': '#TXN002',
        'customer': 'Trần Thị B',
        'amount': '3,200,000',
        'status': 'Đang xử lý',
        'method': 'MoMo',
        'time': '09:15 - 16/11/2025',
      },
      {
        'id': '#TXN003',
        'customer': 'Lê Văn C',
        'amount': '1,800,000',
        'status': 'Thất bại',
        'method': 'ZaloPay',
        'time': '08:45 - 16/11/2025',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTransactionSummary(),
          const SizedBox(height: 16),
          ...transactions.map((txn) => _buildTransactionCard(txn)),
        ],
      ),
    );
  }

  Widget _buildTransactionSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [successColor, successColor.withValues()],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Tổng giao dịch hôm nay',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            '125,000,000 VND',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Thành công',
                  '156',
                  Icons.check_circle,
                ),
              ),
              Expanded(
                child: _buildSummaryItem('Đang xử lý', '12', Icons.pending),
              ),
              Expanded(child: _buildSummaryItem('Thất bại', '3', Icons.error)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildTransactionCard(Map<String, String> txn) {
    Color statusColor;
    switch (txn['status']) {
      case 'Thành công':
        statusColor = successColor;
        break;
      case 'Đang xử lý':
        statusColor = warningColor;
        break;
      default:
        statusColor = dangerColor;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.payment, color: statusColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        txn['id']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        txn['customer']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${txn['amount']} VND',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      txn['status']!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.withValues(alpha: 0.2), height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.credit_card, size: 14, color: textSecondaryColor),
                  const SizedBox(width: 4),
                  Text(
                    txn['method']!,
                    style: TextStyle(fontSize: 12, color: textSecondaryColor),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: textSecondaryColor),
                  const SizedBox(width: 4),
                  Text(
                    txn['time']!,
                    style: TextStyle(fontSize: 12, color: textSecondaryColor),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueExpenseTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildRevenueExpenseChart(),
          const SizedBox(height: 16),
          _buildExpenseBreakdown(),
        ],
      ),
    );
  }

  Widget _buildRevenueExpenseChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thu - Chi tháng này',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: successColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            color: successColor,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Thu nhập',
                            style: TextStyle(
                              fontSize: 12,
                              color: textSecondaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '125M',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: successColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: dangerColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.arrow_downward,
                            color: dangerColor,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Chi phí',
                            style: TextStyle(
                              fontSize: 12,
                              color: textSecondaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '45M',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: dangerColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lợi nhuận ròng',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const Text(
                  '80,000,000 VND',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseBreakdown() {
    final expenses = [
      {'category': 'Bảo trì xe', 'amount': '15M', 'percent': 33.3},
      {'category': 'Nhân sự', 'amount': '18M', 'percent': 40.0},
      {'category': 'Marketing', 'amount': '8M', 'percent': 17.8},
      {'category': 'Vận hành', 'amount': '4M', 'percent': 8.9},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phân loại chi phí',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          ...expenses.map(
            (expense) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        expense['category'] as String,
                        style: TextStyle(fontSize: 13, color: textColor),
                      ),
                      Text(
                        expense['amount'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (expense['percent'] as double) / 100,
                      backgroundColor: Colors.grey.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildComplianceStatus(),
          const SizedBox(height: 16),
          _buildTaxInfo(),
          const SizedBox(height: 16),
          _buildAuditTrail(),
        ],
      ),
    );
  }

  Widget _buildComplianceStatus() {
    final items = [
      {
        'title': 'Báo cáo thuế tháng 11',
        'status': 'Đã nộp',
        'color': successColor,
      },
      {
        'title': 'Giấy phép kinh doanh',
        'status': 'Còn hiệu lực',
        'color': successColor,
      },
      {'title': 'Bảo hiểm xe', 'status': 'Sắp hết hạn', 'color': warningColor},
      {
        'title': 'Chứng nhận an toàn',
        'status': 'Cần gia hạn',
        'color': dangerColor,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trạng thái tuân thủ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => _buildComplianceItem(
              item['title'] as String,
              item['status'] as String,
              item['color'] as Color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceItem(String title, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.verified, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin thuế',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildTaxRow('Thuế GTGT (10%)', '12,500,000 VND'),
          _buildTaxRow('Thuế TNDN (20%)', '16,000,000 VND'),
          _buildTaxRow('Tổng cộng', '28,500,000 VND', isBold: true),
        ],
      ),
    );
  }

  Widget _buildTaxRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? dangerColor : textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditTrail() {
    final logs = [
      'Xuất báo cáo thuế tháng 11 - 15/11/2025',
      'Cập nhật thông tin bảo hiểm - 10/11/2025',
      'Thanh toán phí dịch vụ - 05/11/2025',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nhật ký kiểm toán',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          ...logs.map(
            (log) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 6, color: textSecondaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      log,
                      style: TextStyle(fontSize: 13, color: textSecondaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
