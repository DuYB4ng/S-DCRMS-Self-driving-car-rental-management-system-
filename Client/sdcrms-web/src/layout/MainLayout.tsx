import React from "react";
import Sidebar from "../common/Sidebar";

type Props = {
  children: React.ReactNode;
};

const MainLayout: React.FC<Props> = ({ children }) => {
  return (
    <div
      style={{
        display: "flex",
        minHeight: "100vh",
        backgroundColor: "#f5f5f5",
      }}
    >
      <Sidebar />
      <main style={{ flex: 1, padding: "16px 24px" }}>{children}</main>
    </div>
  );
};

export default MainLayout;
