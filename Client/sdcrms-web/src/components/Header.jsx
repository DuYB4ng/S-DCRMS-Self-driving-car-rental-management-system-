import React from "react";
import { MenuIcon, SearchIcon, BellIcon, UserIcon } from "lucide-react";

const Header = ({ onMenuClick }) => {
  return (
    <header className="bg-[#2E7D9A] shadow-lg sticky top-0 z-30">
      <div className="flex items-center justify-between px-6 py-4">
        {/* Left: Menu Button + Search */}
        <div className="flex items-center gap-4 flex-1">
          <button
            onClick={onMenuClick}
            className="lg:hidden text-white p-2 hover:bg-white/10 rounded-lg transition-all duration-200"
          >
            <MenuIcon className="w-6 h-6" />
          </button>

          <div className="hidden md:flex items-center bg-white/20 backdrop-blur-sm rounded-lg px-4 py-2.5 flex-1 max-w-md shadow-sm">
            <SearchIcon className="w-5 h-5 text-white/80" />
            <input
              type="text"
              placeholder="Tìm kiếm..."
              className="bg-transparent border-none outline-none text-white placeholder:text-white/70 ml-2 w-full text-sm"
            />
          </div>
        </div>

        {/* Right: Notifications + Profile */}
        <div className="flex items-center gap-3">
          <button className="relative p-2.5 text-white hover:bg-white/10 rounded-lg transition-all duration-200">
            <BellIcon className="w-6 h-6" />
            <span className="absolute top-1.5 right-1.5 w-2.5 h-2.5 bg-red-500 rounded-full border-2 border-[#2E7D9A] animate-pulse" />
          </button>

          <div className="flex items-center gap-3 bg-white/20 backdrop-blur-sm rounded-lg px-4 py-2 shadow-sm">
            <div className="w-9 h-9 bg-white rounded-full flex items-center justify-center shadow-md">
              <UserIcon className="w-5 h-5 text-[#2E7D9A]" />
            </div>
            <div className="hidden md:block">
              <p className="text-white text-sm font-bold leading-tight">
                Admin
              </p>
              <p className="text-white/80 text-xs">Administrator</p>
            </div>
          </div>
        </div>
      </div>
    </header>
  );
};

export default Header;
