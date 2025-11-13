import React from "react";

const OwnerCarTable = ({ ownerCars, onEdit, onDelete }) => {
  return (
    <table className="min-w-full bg-white shadow rounded-lg">
      <thead className="bg-gray-100 text-gray-700">
        <tr>
          <th className="p-3 text-left">ID</th>
          <th className="p-3 text-left">Driving Licence</th>
          <th className="p-3 text-left">Issue Date</th>
          <th className="p-3 text-left">Expiry Date</th>
          <th className="p-3 text-left">Active</th>
          <th className="p-3 text-center">Actions</th>
        </tr>
      </thead>
      <tbody>
        {ownerCars.map((oc) => (
          <tr key={oc.ownerCarId} className="border-t">
            <td className="p-3">{oc.ownerCarId}</td>
            <td className="p-3">{oc.drivingLicence}</td>
            <td className="p-3">{new Date(oc.licenceIssueDate).toLocaleDateString()}</td>
            <td className="p-3">{new Date(oc.licenceExpiryDate).toLocaleDateString()}</td>
            <td className="p-3">{oc.isActive ? "✅" : "❌"}</td>
            <td className="p-3 text-center space-x-2">
              <button
                onClick={() => onEdit(oc)}
                className="px-3 py-1 bg-blue-500 text-white rounded hover:bg-blue-600"
              >
                Edit
              </button>
              <button
                onClick={() => onDelete(oc.ownerCarId)}
                className="px-3 py-1 bg-red-500 text-white rounded hover:bg-red-600"
              >
                Delete
              </button>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
};

export default OwnerCarTable;
