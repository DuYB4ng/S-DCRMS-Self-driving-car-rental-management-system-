const API_BASE_URL = "http://localhost:5100/api";

// Get all admins
export const getAllAdmins = async () => {
  const response = await fetch(`${API_BASE_URL}/admin`);
  if (!response.ok) throw new Error("Failed to fetch admins");
  return response.json();
};

// Get admin by ID
export const getAdminById = async (id) => {
  const response = await fetch(`${API_BASE_URL}/admin/${id}`);
  if (!response.ok) throw new Error("Failed to fetch admin");
  return response.json();
};

// Get dashboard statistics
export const getDashboardData = async () => {
  const response = await fetch(`${API_BASE_URL}/admin/dashboard`);
  if (!response.ok) throw new Error("Failed to fetch dashboard data");
  return response.json();
};

// Create new admin
export const createAdmin = async (adminData) => {
  const response = await fetch(`${API_BASE_URL}/admin`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(adminData),
  });
  if (!response.ok) throw new Error("Failed to create admin");
  return response.json();
};

// Promote user to different role
export const promoteUser = async (userId, newRole) => {
  const response = await fetch(
    `${API_BASE_URL}/admin/promote-user/${userId}?newRole=${newRole}`,
    {
      method: "POST",
    }
  );
  if (!response.ok) throw new Error("Failed to promote user");
  return response.json();
};
