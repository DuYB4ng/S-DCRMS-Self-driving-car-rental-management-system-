import { useEffect, useState } from "react";
import { getAllOwnerCars, createOwnerCar } from "../api/ownerCarApi";
import Table from "../components/Table";
import Button from "../components/Button";

export default function OwnerCars() {
  const [owners, setOwners] = useState([]);
  const [form, setForm] = useState({ name: "", phone: "" });

  useEffect(() => {
    loadOwners();
  }, []);

  async function loadOwners() {
    const data = await getAllOwnerCars();
    setOwners(data);
  }

  async function handleAdd() {
    await createOwnerCar(form);
    setForm({ name: "", phone: "" });
    loadOwners();
  }

  return (
    <div className="p-6">
      <h1 className="text-2xl font-semibold mb-4">Danh sách chủ xe</h1>
      <div className="flex gap-2 mb-4">
        <input
          value={form.name}
          onChange={(e) => setForm({ ...form, name: e.target.value })}
          placeholder="Tên"
          className="border rounded px-2 py-1"
        />
        <input
          value={form.phone}
          onChange={(e) => setForm({ ...form, phone: e.target.value })}
          placeholder="SĐT"
          className="border rounded px-2 py-1"
        />
        <Button onClick={handleAdd}>Thêm</Button>
      </div>
      <Table data={owners} columns={["ownerCarID", "name", "phone"]} />
    </div>
  );
}
