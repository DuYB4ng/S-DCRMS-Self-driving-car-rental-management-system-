import { useEffect, useState } from "react";
import { adminApi } from "../api/adminApi";

export default function AdminUsers({ token }) {
  const [users, setUsers] = useState([]);

  const loadUsers = () => {
    adminApi(token)
      .get("/users")
      .then(res => setUsers(res.data))
      .catch(err => console.error(err));
  };

  useEffect(() => {
    loadUsers();
  }, [token]);

  const updateRole = (userId, role) => {
    adminApi(token)
      .put(`/users/${userId}/role`, { role })
      .then(() => loadUsers())
      .catch(err => alert("Update failed"));
  };

  return (
    <div>
      <h2>User Management</h2>

      <table border="1" cellPadding="8">
        <thead>
          <tr>
            <th>Email</th>
            <th>Role</th>
            <th>Change</th>
          </tr>
        </thead>

        <tbody>
          {users.map(u => (
            <tr key={u.id}>
              <td>{u.email}</td>
              <td>{u.role}</td>
              <td>
                <select
                  value={u.role}
                  onChange={(e) => updateRole(u.id, e.target.value)}
                >
                  <option value="Customer">Customer</option>
                  <option value="Staff">Staff</option>
                  <option value="Admin">Admin</option>
                </select>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
