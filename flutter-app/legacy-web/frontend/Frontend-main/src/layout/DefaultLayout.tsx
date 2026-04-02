import React, { useState, useEffect, ReactNode } from 'react';
import Header from '../components/Header/index';
import Sidebar from '../components/Sidebar/index';

interface DefaultLayoutProps {
  handleLogout: () => void;
  children: ReactNode;
  setSearchedData: React.Dispatch<React.SetStateAction<string | null>>;
}

const DefaultLayout: React.FC<DefaultLayoutProps> = ({ children, handleLogout, setSearchedData }) => {
  const [sidebarOpen, setSidebarOpen] = useState<boolean>(() => {
    // Retrieve sidebar state from localStorage on mount
    const savedState = localStorage.getItem('sidebarOpen');
    return savedState ? JSON.parse(savedState) : false;
  });

  // Update localStorage whenever sidebarOpen state changes
  useEffect(() => {
    localStorage.setItem('sidebarOpen', JSON.stringify(sidebarOpen));
  }, [sidebarOpen]);

  return (
    <div className="dark:bg-boxdark-2 dark:text-bodydark">
      {/* <!-- ===== Page Wrapper Start ===== --> */}
      <div className="flex h-screen overflow-hidden">
        {/* <!-- ===== Sidebar Start ===== --> */}
        {sidebarOpen && <Sidebar sidebarOpen={sidebarOpen} setSidebarOpen={setSidebarOpen} />}
        
        {/* <!-- ===== Sidebar End ===== --> */}

        {/* <!-- ===== Content Area Start ===== --> */}
        <div className="relative flex flex-1 flex-col overflow-y-auto overflow-x-hidden">
          {/* <!-- ===== Header Start ===== --> */}
          <Header
            handleLogout={handleLogout}
            sidebarOpen={sidebarOpen}
            setSidebarOpen={setSidebarOpen}
            setSearchedData={setSearchedData}
          />
          {/* <!-- ===== Header End ===== --> */}

          {/* <!-- ===== Main Content Start ===== --> */}
          <main>
            <div className="mx-auto max-w-screen-2xl p-4 md:p-6 2xl:p-10">
              {children}
            </div>
          </main>
          {/* <!-- ===== Main Content End ===== --> */}
        </div>
        {/* <!-- ===== Content Area End ===== --> */}
      </div>
      {/* <!-- ===== Page Wrapper End ===== --> */}
    </div>
  );
};

export default DefaultLayout;
