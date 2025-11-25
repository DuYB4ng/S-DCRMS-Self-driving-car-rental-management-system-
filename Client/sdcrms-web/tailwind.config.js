/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        primary: "#2E7D9A",
        secondary: "#F5F9FA",
        accent: "#3498DB",
        success: "#10B981",
        warning: "#F59E0B",
        danger: "#EF4444",
        cardBg: "#FFFFFF",
        textPrimary: "#2C3E50",
        textSecondary: "#7F8C8D",
      },
      fontFamily: {
        sans: ["Poppins", "system-ui", "-apple-system", "sans-serif"],
      },
    },
  },
  plugins: [],
};
