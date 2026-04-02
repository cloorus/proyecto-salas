import React, { useState, useMemo, useEffect } from 'react';
import { NavLink } from 'react-router-dom';               // Manage routes within the application.
import DropdownUser from './DropdownUser';                // DropdownUser component
import DarkModeSwitcher from './DarkModeSwitcher';        // DarkModeSwitcher component
import Logo from '../../images/logo/icon-s.png';          // Light mode logo
import LogoDark from '../../images/logo/icon-s-dark.png'; // Dark mode logo

// Definition of the props that the Header component accepts
interface HeaderProps {
  sidebarOpen: string | boolean | undefined;                            // Defines the type of the sidebarOpen property
  setSidebarOpen: (arg0: boolean) => void;                              // Defines the function that modifies the state of sidebarOpen
  handleLogout: () => void;                                             // Defines the function that handles the logout
  setSearchedData: React.Dispatch<React.SetStateAction<string | null>>; // Defines the function that updates the search state
}

// Definition of the Header component
const Header: React.FC<HeaderProps> = ({
  sidebarOpen,
  setSidebarOpen,
  handleLogout,
  setSearchedData
}) => {
  const [searchQuery, setSearchQuery] = useState<string>(''); // State to store the search text

  // Memorizes the search result based on the entered text
  const filteredData = useMemo(() => {
    if (!searchQuery) {
      return null;
    }

    return searchQuery.length > 0 ? searchQuery : null;
  }, [searchQuery]); // Updates only when searchQuery changes

  // useEffect that runs every time filteredData changes
  useEffect(() => {
    setSearchedData(filteredData); // Update the search state with the filtered data
  }, [filteredData]);

  return (
    <header className="sticky top-0 z-999 flex w-full bg-white drop-shadow-1 dark:bg-boxdark dark:drop-shadow-none">
      <div className="flex flex-grow items-center justify-between px-4 py-4 shadow-2 md:px-6 2xl:px-11">
        <div className="flex items-center gap-2 sm:gap-4">
          
          {/* Hamburger Toggle BTN */}
          <button
            onClick={(e) => {
              e.stopPropagation();
              setSidebarOpen(!sidebarOpen); // Change the state of the sidebar
            }}
            className=""
          >
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="size-6">
              <path strokeLinecap="round" strokeLinejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
            </svg>

          </button>

          {/* If the sidebar is closed, show the logo */}
          {!sidebarOpen && (
            <div className="h-6">
              <NavLink to="/">
                <img src={Logo} alt="Logo" className="w-full h-full hidden dark:block" />
              </NavLink>
              <NavLink to="/">
                <img src={LogoDark} alt="Logo" className="w-full h-full dark:hidden" />
              </NavLink>
            </div>
          )}
        </div>

        {/* Search bar */}
        <div className="hidden sm:block">
          <div className="relative">
            <button className="absolute left-0 top-1/2 -translate-y-1/2">
              <svg
                className="fill-body hover:fill-primary dark:fill-bodydark dark:hover:fill-primary"
                width="20"
                height="20"
                viewBox="0 0 20 20"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  fillRule="evenodd"
                  clipRule="evenodd"
                  d="M9.16666 3.33332C5.945 3.33332 3.33332 5.945 3.33332 9.16666C3.33332 12.3883 5.945 15 9.16666 15C12.3883 15 15 12.3883 15 9.16666C15 5.945 12.3883 3.33332 9.16666 3.33332ZM1.66666 9.16666C1.66666 5.02452 5.02452 1.66666 9.16666 1.66666C13.3088 1.66666 16.6667 5.02452 16.6667 9.16666C16.6667 13.3088 13.3088 16.6667 9.16666 16.6667C5.02452 16.6667 1.66666 13.3088 1.66666 9.16666Z"
                  fill=""
                />
                <path
                  fillRule="evenodd"
                  clipRule="evenodd"
                  d="M13.2857 13.2857C13.6112 12.9603 14.1388 12.9603 14.4642 13.2857L18.0892 16.9107C18.4147 17.2362 18.4147 17.7638 18.0892 18.0892C17.7638 18.4147 17.2362 18.4147 16.9107 18.0892L13.2857 14.4642C12.9603 14.1388 12.9603 13.6112 13.2857 13.2857Z"
                  fill=""
                />
              </svg>
            </button>

            {/* Search input */}
            <input
              type="text"
              placeholder="Buscar..."
              className="w-full bg-transparent pl-9 pr-4 text-black focus:outline-none dark:text-white xl:w-125"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
          </div>
        </div>
        <div className="flex items-center gap-3 2xsm:gap-7">
          <ul className="flex items-center gap-2 2xsm:gap-4">
            <DarkModeSwitcher />
          </ul>
          <DropdownUser handleLogout={handleLogout} />
        </div>
      </div>
    </header>
  );
};

// Export the component
export default Header;
