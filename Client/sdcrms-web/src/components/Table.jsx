export default function Table({ columns, data }) {
  return (
    <div className="overflow-x-auto bg-white shadow-sm rounded-lg">
      <table className="min-w-full border-collapse">
        <thead>
          <tr className="bg-gray-100 text-gray-700 text-sm uppercase">
            {columns.map((col) => (
              <th key={col.key} className="px-4 py-3 text-left border-b">
                {col.label}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {data.length > 0 ? (
            data.map((row, i) => (
              <tr
                key={i}
                className="hover:bg-gray-50 border-b last:border-none"
              >
                {columns.map((col) => (
                  <td key={col.key} className="px-4 py-2 text-sm text-gray-800">
                    {row[col.key]}
                  </td>
                ))}
              </tr>
            ))
          ) : (
            <tr>
              <td
                colSpan={columns.length}
                className="text-center py-4 text-gray-500"
              >
                Không có dữ liệu
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
}
