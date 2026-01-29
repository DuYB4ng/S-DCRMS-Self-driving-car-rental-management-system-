import "./Admin.css";

const StatCard = ({ title, value, change, isPositive, prefix = "" }) => {
  return (
    <div className="stat-card">
      <div className="stat-header">{title}</div>
      <div className="stat-value">
        {prefix}{value}
      </div>
      {change && (
        <div className={`stat-change ${isPositive ? "positive" : "negative"}`}>
          {isPositive ? "↑" : "↓"} {change}%
        </div>
      )}
    </div>
  );
};

export default StatCard;
