import { useEffect, useMemo, useState } from 'react';
import { getFetch } from '../../utils/apiMethods';
import Breadcrumb from '../Breadcrumbs/Breadcrumb';
import { Activation } from '../../interfaces/Interfaces';
import { getEndpoint, paginateData, dateFormatted, getCurrentUser } from '../../utils/utils';
import DeleteActivationModal from '../Modals/Activation/DeleteActivationModal';

interface TableActivationProps {
  searchedData: string | null;
}

const TableActivation: React.FC<TableActivationProps> = ({ searchedData }) => {
  // State variables for managing  data, UI state, pagination, and modal visibility.
  const [data, setData] = useState<Activation[]>([]);
  const [refreshData, setRefreshData] = useState<boolean>(true);
  const [deleteActivationId, setdeleteActivationId] = useState<number>();
  const [showDeleteModal, setShowDeleteModal] = useState<boolean>(false);

  //Current page of pagination
  const [currentPage, setCurrentPage] = useState<number>(1);

  // Define the endpoint for fetching activation data
  const endpoint = getEndpoint('activations');

  // Handle pagination of data
  const pagination = paginateData(data, currentPage, setCurrentPage);

  // Extract the paginated data for the current page
  const paginatedData = pagination.paginatedData;

  // Get the current user information
  const currentUser = getCurrentUser();

  useEffect(() => {
    // Function to fetch activation data from the API
    const fetchData = async () => {
      try {
        const result = await getFetch(`${endpoint}`);
        setData(result as Activation[]);
        setRefreshData(false);
      } catch (err) {
        console.error("Error fetching data:", err);
      }
    };
    if (refreshData) fetchData();
  }, [refreshData, endpoint]);

  // Memoized function to filter the paginated data based on the searched term
  const filteredData = useMemo(() => {
    if (!searchedData) return paginatedData;

    // Convert the search term to lowercase for case-insensitive comparison
    const searchTerm = searchedData.toLowerCase();

    // Filter the paginated data based on the search term across multiple fields
    return paginatedData.filter(activation =>
      activation.Name_Installer.toLowerCase().includes(searchTerm) ||
      activation.Engine.toLowerCase().includes(searchTerm) ||
      activation.ID_Vita.toString().includes(searchTerm) ||
      activation.Date_Activation.slice(0, 10).toLowerCase().includes(searchTerm)
    );
  }, [searchedData, paginatedData]);

  // Determine if there are matches for the search term
  const hasMatches = searchedData && filteredData.length > 0;

  // Functions to open and hide modals
  const handleOpenDeleteModal = (id: number) => {
    setdeleteActivationId(id);
    setShowDeleteModal(true);
  };

  const handleCloseDeleteModal = () => {
    setShowDeleteModal(false);
  };

return (
  <>
    <Breadcrumb pageName="Activaciones" />
    
    {/* Display the number of matches found if any exist */}
    {hasMatches && <p>Matches found: {filteredData.length}</p>}
    
    <div className="rounded-sm border border-stroke bg-white px-5 pt-6 pb-2.5 shadow-default dark:border-strokedark dark:bg-boxdark sm:px-7.5 xl:pb-1">
      {/* Delete Activation Modal */}
      {showDeleteModal && (
        <DeleteActivationModal
          handleCloseDeleteModal={handleCloseDeleteModal}
          deleteActivationId={deleteActivationId} 
          setRefreshData={setRefreshData} 
          setShowDeleteModal={setShowDeleteModal} 
        />
      )}
      
      <div className="max-w-full overflow-x-auto">
        <table className="w-full table-auto">
          <thead>
            <tr className="bg-gray-2 text-left dark:bg-meta-4">
              <th className="min-w-[120px] py-4 px-4 font-medium text-black dark:text-white xl:pl-11">
                Installer Name
              </th>
              <th className="min-w-[120px] py-4 px-4 font-medium text-black dark:text-white">
                Engine
              </th>
              <th className="min-w-[150px] py-4 px-4 font-medium text-black dark:text-white">
                ID Vita
              </th>
              <th className="min-w-[170px] py-4 px-4 font-medium text-black dark:text-white">
                Activation Date
              </th>
              <th className="py-4 px-4 font-medium text-black dark:text-white"></th>
            </tr>
          </thead>
          <tbody>
            {refreshData ? (
              <tr>
                <td colSpan={7} className="py-5 text-center">Loading data...</td>
              </tr>
            ) : (
              // If there are filtered results display them, otherwise display all
              filteredData.length > 0 ? (
                filteredData.map((item, key) => (
                  <tr key={key}>
                    <td className="border-b border-[#eee] py-5 px-4 pl-9 dark:border-strokedark xl:pl-11">
                      <p className="text-black dark:text-white">
                        {item.Name_Installer}
                      </p>
                    </td>
                    <td className="border-b border-[#eee] py-5 px-4 dark:border-strokedark">
                      <p className="text-black dark:text-white">
                        {item.Engine}
                      </p>
                    </td>
                    <td className="border-b border-[#eee] py-5 px-4 dark:border-strokedark">
                      <p className="text-black dark:text-white">
                        {item.ID_Vita}
                      </p>
                    </td>
                    <td className="border-b border-[#eee] py-5 px-4 dark:border-strokedark">
                      <p className="text-black dark:text-white">
                        {dateFormatted(item.Date_Activation.slice(0, 10), "cr")}
                      </p>
                    </td>
                    <td className="border-b border-[#eee] py-5 px-4 dark:border-strokedark">
                      <div className="flex items-center space-x-3.5">
                        {/* Show delete button if the current user has the appropriate role */}
                        {(currentUser.ID_Role === 1) && (
                          <button
                            onClick={() => handleOpenDeleteModal(item.ID_Activation)} 
                            className="hover:text-primary"
                          >
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
                              <path strokeLinecap="round" strokeLinejoin="round" d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0" />
                            </svg>
                          </button>
                        )}
                      </div>
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td colSpan={7} className="py-5 text-center">No matches found.</td>
                </tr>
              ))}
          </tbody>
        </table>
      </div>
      
      {/* Pagination controls */}
      {(paginatedData.length >= 50 || pagination.isLastPage) && (
        <div className="flex items-center justify-center my-4">
          <button className='rounded bg-primary mt-4 py-1 px-2 text-base font-medium text-white shadow-button transition hover:opacity-80' onClick={pagination.handlePrevPage} disabled={currentPage === 1}>
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="size-6">
              <path strokeLinecap="round" strokeLinejoin="round" d="M10.5 19.5 3 12m0 0 7.5-7.5M3 12h18" />
            </svg>
          </button>
          <span className='ml-6 mt-4'>
            Page {currentPage} of {pagination.totalPages}
          </span>
          <button className='ml-6 rounded bg-primary mt-4 py-1 px-2 text-base font-medium text-white shadow-button transition hover:opacity-80' onClick={pagination.handleNextPage} disabled={currentPage === pagination.totalPages}>
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="size-6">
              <path strokeLinecap="round" strokeLinejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3" />
            </svg>
          </button>
        </div>
      )}
    </div>
  </>
);

};

export default TableActivation;
