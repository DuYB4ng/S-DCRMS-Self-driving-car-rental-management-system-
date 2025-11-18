import React from "react";

const fakeReports = [
  { id: 1, title: "Xe bị trầy xước", status: "Đang xử lý" },
  { id: 2, title: "Khách trả xe trễ", status: "Đã xử lý" },
];

const ReportsPage: React.FC = () => {
  return (
    <>
      {/* CSS nhúng, không cần file .css riêng */}
      <style>{`
        :root {
          --primary: #1E90FF;
          --primary-light: #63b3ff;
        }

        .reports-page {
          padding: 32px;
          background: #f5faff;
          min-height: 100vh;
        }

        .reports-card {
          max-width: 900px;
          margin: 0 auto;
          background-color: #ffffff;
          border-radius: 16px;
          border: 1px solid #e2e8f0;
          box-shadow: 0 4px 12px rgba(15, 23, 42, 0.08);
          padding: 24px 28px;
        }

        .reports-card__header {
          display: flex;
          align-items: center;
          justify-content: space-between;
          margin-bottom: 20px;
        }

        .reports-card__header h1 {
          font-size: 28px;
          font-weight: 700;
          margin: 0;
          color: #1a1a1a;
        }

        .reports-card__button {
          padding: 8px 16px;
          border-radius: 999px;
          border: none;
          background: var(--primary);
          color: #fff;
          font-size: 14px;
          font-weight: 600;
          cursor: pointer;
          box-shadow: 0 2px 6px rgba(30, 144, 255, 0.4);
          transition: background 0.2s ease, transform 0.1s ease;
        }

        .reports-card__button:hover {
          background: var(--primary-light);
          transform: translateY(-1px);
        }

        .reports-table {
          width: 100%;
          border-collapse: collapse;
          font-size: 16px;
        }

        .reports-table thead th {
          text-align: left;
          padding-bottom: 10px;
          color: var(--primary);
          border-bottom: 2px solid var(--primary);
        }

        .reports-table tbody td {
          padding: 12px 0;
          border-bottom: 1px solid #f0f0f0;
          color: #333;
        }

        .reports-table tbody tr:hover td {
          background-color: #f5faff;
        }

        .status-chip {
          display: inline-block;
          padding: 4px 10px;
          border-radius: 999px;
          font-size: 12px;
          font-weight: 500;
        }

        .status-pending {
          background-color: #fef3c7;
          color: #92400e;
        }

        .status-done {
          background-color: #dcfce7;
          color: #166534;
        }
      `}</style>

      <div className="reports-page">
        <div className="reports-card">
          <div className="reports-card__header">
            <h1>Báo cáo</h1>
            <button className="reports-card__button">+ Tạo báo cáo mới</button>
          </div>

          <table className="reports-table">
            <thead>
              <tr>
                <th>Tiêu đề báo cáo</th>
                <th>Trạng thái</th>
              </tr>
            </thead>
            <tbody>
              {fakeReports.map((r) => (
                <tr key={r.id}>
                  <td>{r.title}</td>
                  <td>
                    <span
                      className={
                        "status-chip " +
                        (r.status === "Đang xử lý"
                          ? "status-pending"
                          : "status-done")
                      }
                    >
                      {r.status}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
};

export default ReportsPage;
