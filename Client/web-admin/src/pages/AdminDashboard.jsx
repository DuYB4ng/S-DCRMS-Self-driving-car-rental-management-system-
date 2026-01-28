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
      const totalRevenue = bookings.reduce((sum, b) => sum + (b.totalAmount || 0), 0);
      const totalOrders = bookings.length;
      const avgRevenue = totalOrders > 0 ? (totalRevenue / totalOrders).toFixed(0) : 0;

      setStats({
        revenue: totalRevenue,
        orders: totalOrders,
        avgRevenue: avgRevenue,
      });

      // 2. Prepare Chart Data (Group by Date)
      const groupedByDate = bookings.reduce((acc, b) => {
        const date = new Date(b.createdAt).toLocaleDateString("en-US", { month: "short", day: "numeric" });
        if (!acc[date]) acc[date] = 0;
        acc[date] += (b.totalAmount || 0);
        return acc;
      }, {});

      const chart = Object.keys(groupedByDate).map(date => ({
        name: date,
        revenue: groupedByDate[date]
      })).slice(-7); // Last 7 days/entries

      setChartData(chart);

      // 3. Recent Orders
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
          <div className="dashboard-grid">
            <StatCard 
              title="Total Revenue" 
              value={stats.revenue.toLocaleString()} 
              prefix="$" 
              change={12.5} 
              isPositive={true} 
            />
            <StatCard 
              title="Total Orders" 
              value={stats.orders} 
              change={5.2} 
              isPositive={true} 
            />
            <StatCard 
              title="Avg. Revenue Per User" 
              value={stats.avgRevenue.toLocaleString()} 
              prefix="$" 
              change={-2.4} 
              isPositive={false} 
            />
            <StatCard 
              title="Refunds" 
              value="0.00" 
              change={0} 
              isPositive={true} 
            />
          </div>

          <div className="charts-grid">
            {/* Revenue Chart */}
            <div className="card">
              <h3 className="card-title">Revenue Overview</h3>
              <div style={{ width: "100%", height: 300 }}>
                <ResponsiveContainer>
                  <AreaChart data={chartData}>
                    <defs>
                      <linearGradient id="colorRevenue" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="#8884d8" stopOpacity={0.8}/>
                        <stop offset="95%" stopColor="#8884d8" stopOpacity={0}/>
                      </linearGradient>
                    </defs>
                    <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" />
                    <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{fill: '#94a3b8', fontSize: 12}} />
                    <YAxis axisLine={false} tickLine={false} tick={{fill: '#94a3b8', fontSize: 12}} />
                    <Tooltip />
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

            {/* Customer Acquisition (Mock or secondary chart) */}
             <div className="card">
              <h3 className="card-title">Customer Acquisition</h3>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', height: 300, color: '#94a3b8' }}>
                Chart Placeholder
              </div>
            </div>
          </div>

          {/* Recent Orders Table */}
          <div className="card">
            <h3 className="card-title">Recent Orders</h3>
            <div className="table-container">
              <table>
                <thead>
                  <tr>
                    <th>Booking ID</th>
                    <th>Date</th>
                    <th>Car ID</th>
                    <th>Amount</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  {recentOrders.map((order) => (
                    <tr key={order.bookingID}>
                      <td>#{order.bookingID}</td>
                      <td>{new Date(order.createdAt).toLocaleDateString()}</td>
                      <td>{order.carId}</td>
                      <td>${(order.totalAmount || 0).toLocaleString()}</td>
                      <td>
                        <span className={`status-badge ${
                          order.status === 'Completed' ? 'status-completed' : 
                          order.status === 'Cancelled' ? 'status-canceled' : 'status-pending'
                        }`}>
                          {order.status}
                        </span>
                      </td>
                    </tr>
                  ))}
                  {recentOrders.length === 0 && (
                    <tr>
                      <td colSpan="5" style={{textAlign: 'center', padding: 20}}>No orders found</td>
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
