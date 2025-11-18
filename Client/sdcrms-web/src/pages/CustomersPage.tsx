import React from "react";

const fakeOwners = [
  { id: 1, name: "Nguyễn Văn A", phone: "0901 234 567", cars: 3 },
  { id: 2, name: "Trần Thị B", phone: "0902 345 678", cars: 5 },
];

const OwnersPage: React.FC = () => {
  return (
    <>
      {/* CSS nhúng, không cần file .css riêng */}
      <style>{`
        :root {
          --primary: #1E90FF;
          --primary-light: #63b3ff;
        }

        .owners-page {
          padding: 32px;
          background: #f5faff;
          min-height: 100vh;
        }

        .owners-card {
          max-width: 900px;
          margin: 0 auto;
          background-color: #ffffff;
          border-radius: 16px;
          border: 1px solid #e2e8f0;
          box-shadow: 0 4px 12px rgba(15, 23, 42, 0.08);
          padding: 24px 28px;
        }

        .owners-card__header {
          display: flex;
          align-items: center;
          justify-content: space-between;
          margin-bottom: 20px;
        }

        .owners-card__header h1 {
          font-size: 28px;
          font-weight: 700;
          margin: 0;
          color: #1a1a1a;
        }

        .owners-card__button {
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

        .owners-card__button:hover {
          background: var(--primary-light);
          transform: translateY(-1px);
        }

        .owners-table {
          width: 100%;
          border-collapse: collapse;
          font-size: 16px;
        }

        .owners-table thead th {
          text-align: left;
          padding-bottom: 10px;
          color: var(--primary);
          border-bottom: 2px solid var(--primary);
        }

        .owners-table tbody td {
          padding: 12px 0;
          border-bottom: 1px solid #f0f0f0;
          color: #333;
        }

        .owners-table tbody tr:hover td {
          background-color: #f5faff;
        }
      `}</style>

      <div className="owners-page">
        <div className="owners-card">
          <div className="owners-card__header">
            <h1>Quản lý khách hàng</h1>
            <button className="owners-card__button">+ Thêm khách hàng</button>
          </div>

          <table className="owners-table">
            <thead>
              <tr>
                <th>Tên chủ xe</th>
                <th>SĐT</th>
                <th>Số lượng khách hàng</th>
              </tr>
            </thead>
            <tbody>
              {fakeOwners.map((o) => (
                <tr key={o.id}>
                  <td>{o.name}</td>
                  <td>{o.phone}</td>
                  <td>{o.cars}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
};

export default OwnersPage;
