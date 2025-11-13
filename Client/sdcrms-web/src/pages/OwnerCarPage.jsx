import React, { useEffect, useState } from "react";
import { getAllOwnerCars, createOwnerCar, updateOwnerCar, deleteOwnerCar } from "../api/ownerCarApi";
import OwnerCarForm from "../components/OwnerCarForm";
import OwnerCarTable from "../components/OwnerCarTable";


const OwnerCarPage = () => {
  const [ownerCars, setOwnerCars] = useState([]);
  const [editing, setEditing] = useState(null);
  const [showForm, setShowForm] = useState(false);

  const loadData = async () => {
    const data = await getAllOwnerCars();
    setOwnerCars(data);
  };

  useEffect(() => {
    loadData();
  }, []);

  const handleSave = async (data) => {
    if (editing) {
      await updateOwnerCar(data.ownerCarId, data);
    } else {
      await createOwnerCar(data);
    }
    setShowForm(false);
    setEditing(null);
    await loadData();
  };

  const handleDelete = async (id) => {
    if (confirm("Bạn có chắc muốn xóa?")) {
      await deleteOwnerCar(id);
      await loadData();
    }
  };

  return (
    <div className="p-6 max-w-5xl mx-auto">
      <h1 className="text-2xl font-bold mb-4">Quản lý chủ xe</h1>

      <button
        onClick={() => {
          setEditing(null);
          setShowForm(true);
        }}
        className="mb-4 px-4 py-2 bg-blue-500 text-white rounded"
      >
        + Thêm chủ xe
      </button>

      {showForm && (
        <OwnerCarForm
          initialData={editing}
          onSubmit={handleSave}
          onCancel={() => setShowForm(false)}
        />
      )}

      <OwnerCarTable
        ownerCars={ownerCars}
        onEdit={(oc) => {
          setEditing(oc);
          setShowForm(true);
        }}
        onDelete={handleDelete}
      />
    </div>
  );
};

export default OwnerCarPage;
