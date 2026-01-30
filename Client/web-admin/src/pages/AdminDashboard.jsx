import { useEffect, useState } from "react";
import axiosClient from "../api/axiosClient";
import Sidebar from "../components/admin/Sidebar";
import Header from "../components/admin/Header";
import StatCard from "../components/admin/StatCard";
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from "recharts";
import "../components/admin/Admin.css";

function AdminDashboard() {
  const [stats, setStats] = useState({
    revenue: 0,
    orders: 0,
    avgRevenue: 0,
    deposits: 0,
    withdrawals: 0
  });
  const [chartData, setChartData] = useState([]);
  const [recentOrders, setRecentOrders] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const fetchDashboardData = async () => {
    try {
      // Fetch bookings (Assumes API /booking retrieves all bookings)
      // Note: Backend must be rebuilt to include 'totalAmount' in BookingDto
      const res = await axiosClient.get("/booking");
      const bookings = res.data;

      // 1. Calculate Stats
      // 1. Calculate Stats
      const COMMISSION_RATE = 0.1; // 10% commission
      const validBookings = bookings.filter(b => b.status !== 'Cancelled');

      const totalBookingValue = validBookings.reduce((sum, b) => sum + (b.totalPrice || b.totalAmount || 0), 0);
      // Revenue is 10% of total booking value (commission)
      const totalRevenue = totalBookingValue * COMMISSION_RATE;

      const totalOrders = bookings.length;
      const avgRevenue = totalOrders > 0 ? (totalRevenue / totalOrders).toFixed(0) : 0;

      setStats({
        revenue: totalRevenue,
        orders: totalOrders,
        avgRevenue: avgRevenue,
      });

      // 3. Transactions Stats
      let totalDeposits = 0;
      let totalWithdrawals = 0;
      try {
        const transRes = await axiosClient.get("/wallet/transactions");
        const transactions = transRes.data;
        totalDeposits = transactions
          .filter(t => t.transactionType === "TopUp" && t.status === "Completed")
          .reduce((sum, t) => sum + t.amount, 0);

        totalWithdrawals = transactions
          .filter(t => t.transactionType === "Withdraw" && t.status === "Completed")
          .reduce((sum, t) => sum + t.amount, 0);
      } catch (err) {
        console.error("Error fetching transactions:", err);
      }

      setStats({
        revenue: totalRevenue,
        orders: totalOrders,
        avgRevenue: avgRevenue,
        deposits: totalDeposits,
        withdrawals: totalWithdrawals
      });

      // 4. Prepare Chart Data (Group by Date)
      const groupedByDate = validBookings.reduce((acc, b) => {
        const date = new Date(b.createdAt).toLocaleDateString("vi-VN", { month: "numeric", day: "numeric" });
        if (!acc[date]) acc[date] = 0;
        acc[date] += ((b.totalPrice || b.totalAmount || 0) * COMMISSION_RATE);
        return acc;
      }, {});

      const chart = Object.keys(groupedByDate).map(date => ({
        name: date,
        revenue: groupedByDate[date]
      })).slice(-7); // Last 7 days/entries

      setChartData(chart);

      // 5. Recent Orders
      setRecentOrders(bookings.slice(0, 5)); // Taking first 5 (assuming API returns descending)
    } catch (error) {
      console.error("Failed to fetch dashboard data:", error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div className="admin-container">Loading...</div>;

  return (
    <div className="admin-container">
      <Sidebar />
      <div className="main-content">
        <Header />

        <div className="dashboard-page">
          <div className="dashboard-grid" style={{ gridTemplateColumns: "repeat(5, 1fr)" }}>
            <StatCard
              title="Doanh thu hệ thống"
              value={stats.revenue.toLocaleString('vi-VN')}
              prefix="₫"
              isPositive={true}
            />
            <StatCard
              title="Tổng đơn hàng"
              value={stats.orders}
              isPositive={true}
            />
            <StatCard
              title="Doanh thu TB / Đơn"
              value={stats.avgRevenue.toLocaleString('vi-VN')}
              prefix="₫"
              isPositive={false}
            />
            <StatCard
              title="Tổng nạp tiền"
              value={stats.deposits.toLocaleString('vi-VN')}
              prefix="₫"
              isPositive={true}
            />
            <StatCard
              title="Tổng rút tiền"
              value={stats.withdrawals.toLocaleString('vi-VN')}
              prefix="₫"
              isPositive={false}
            />
          </div>

          <div className="charts-grid">
            {/* Revenue Chart */}
            <div className="card">
              <h3 className="card-title">Tổng quan doanh thu</h3>
              <div style={{ width: "100%", height: 300 }}>
                <ResponsiveContainer>
                  <AreaChart data={chartData}>
                    <defs>
                      <linearGradient id="colorRevenue" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="#8884d8" stopOpacity={0.8} />
                        <stop offset="95%" stopColor="#8884d8" stopOpacity={0} />
                      </linearGradient>
                    </defs>
                    {/* <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" /> */}
                    <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{ fill: '#94a3b8', fontSize: 12 }} />
                    <YAxis axisLine={false} tickLine={false} tick={{ fill: '#94a3b8', fontSize: 12 }} />
                    <Tooltip formatter={(value) => [value.toLocaleString('vi-VN') + ' đ', 'Doanh thu']} />
                    <Area
                      type="monotone"
                      dataKey="revenue"
                      stroke="#8884d8"
                      fillOpacity={1}
                      fill="url(#colorRevenue)"
                    />
                  </AreaChart>
                </ResponsiveContainer>
              </div>
            </div>
          </div>

          {/* Recent Orders Table */}
          <div className="card">
            <h3 className="card-title">Đơn hàng mới</h3>
            <div className="table-container">
              <table>
                <thead>
                  <tr>
                    <th>Mã đơn</th>
                    <th>Ngày tạo</th>
                    <th>Mã xe</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                  </tr>
                </thead>
                <tbody>
                  {recentOrders.map((order) => (
                    <tr key={order.bookingID}>
                      <td>#{order.bookingID}</td>
                      <td>{new Date(order.createdAt).toLocaleDateString('vi-VN')}</td>
                      <td>{order.carId}</td>
                      <td>{(order.totalPrice || order.totalAmount || 0).toLocaleString('vi-VN')} đ</td>
                      <td>
                        <span className={`status-badge ${order.status === 'Completed' ? 'status-completed' :
                          order.status === 'Cancelled' ? 'status-canceled' : 'status-pending'
                          }`}>
                          {order.status === 'Completed' ? 'Hoàn thành' :
                            order.status === 'Cancelled' ? 'Đã hủy' :
                              order.status === 'Pending' ? 'Chờ duyệt' :
                                order.status === 'Paid' ? 'Đã thanh toán' :
                                  order.status === 'Approved' ? 'Đã duyệt' :
                                    order.status === 'InProgress' ? 'Đang thuê' :
                                      order.status === 'ReturnRequested' ? 'Yêu cầu trả xe' :
                                        order.status}
                        </span>
                      </td>
                    </tr>
                  ))}
                  {recentOrders.length === 0 && (
                    <tr>
                      <td colSpan="5" style={{ textAlign: 'center', padding: 20 }}>Không có đơn hàng nào</td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>

        </div>
      </div>
    </div>
  );
}

export default AdminDashboard;
