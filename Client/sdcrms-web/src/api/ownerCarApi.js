const API_BASE = "https://localhost:5100/api/ownercar";

export async function getAllOwnerCars() {
  const res = await fetch(API_BASE);
  if (!res.ok) throw new Error("Không thể lấy danh sách chủ xe");
  return res.json();
}

export async function createOwnerCar(data) {
  const res = await fetch(API_BASE, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error("Tạo chủ xe thất bại");
  return res.json();
}
