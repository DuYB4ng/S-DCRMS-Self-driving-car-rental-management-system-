import React, { useState, useEffect } from "react";

const OwnerCarForm = ({ initialData, onSubmit, onCancel }) => {
  const [formData, setFormData] = useState({
    ownerCarId: 0,
    drivingLicence: "",
    licenceIssueDate: "",
    licenceExpiryDate: "",
    isActive: true,
  });

  useEffect(() => {
    if (initialData) setFormData(initialData);
  }, [initialData]);

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData({ ...formData, [name]: type === "checkbox" ? checked : value });
  };

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        onSubmit(formData);
      }}
      className="bg-white p-4 rounded shadow-md"
    >
      <input
        type="text"
        name="drivingLicence"
        value={formData.drivingLicence}
        onChange={handleChange}
        placeholder="Driving Licence"
        className="border p-2 w-full mb-2 rounded"
        required
      />
      <label>Issue Date</label>
      <input
        type="date"
        name="licenceIssueDate"
        value={formData.licenceIssueDate}
        onChange={handleChange}
        className="border p-2 w-full mb-2 rounded"
        required
      />
      <label>Expiry Date</label>
      <input
        type="date"
        name="licenceExpiryDate"
        value={formData.licenceExpiryDate}
        onChange={handleChange}
        className="border p-2 w-full mb-2 rounded"
        required
      />
      <div className="flex items-center mb-2">
        <input
          type="checkbox"
          name="isActive"
          checked={formData.isActive}
          onChange={handleChange}
          className="mr-2"
        />
        <label>Active</label>
      </div>
      <div className="flex justify-end space-x-2">
        <button type="button" onClick={onCancel} className="px-3 py-1 border rounded">
          Cancel
        </button>
        <button type="submit" className="px-3 py-1 bg-green-500 text-white rounded">
          Save
        </button>
      </div>
    </form>
  );
};

export default OwnerCarForm;
