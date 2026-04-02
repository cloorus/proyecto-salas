import { useMemo } from "react";
import { postFetch } from "./apiMethods";
import { toast } from "react-toastify";

// Function to get the current user logged
export const getCurrentUser = () => {
  const currentUser = localStorage.getItem('currentUser');
  return JSON.parse(currentUser ? currentUser : '{}');
};

// Function to get the right endpoint by user Role
export const getEndpoint = (endpoint: string) => {
  const currentUser = getCurrentUser();
  if (currentUser.ID_Role === 2 || currentUser.ID_Role === 3 || currentUser.ID_Role === 4) return `${endpoint}/${currentUser.ID_Person}`;
  if (currentUser.ID_Role === 5 || currentUser.ID_Role === 6) return `${endpoint}/${currentUser.ID_Person}/${currentUser.ID_Person}`
  if (currentUser.ID_Role === 1) return `${endpoint}`;
};

// Function to handle pagination in every table
export const paginateData = (
  data: any[],
  currentPage: number,
  setCurrentPage: (page: number) => void
) => {

  const dataDescOrder = [...data].reverse()
  const itemsPerPage = 50; // Number of items to show per page
  const totalPages = Math.ceil(data.length / itemsPerPage);

  // Data paginated based on the current page
  const paginatedData = useMemo(() => {
    const startIndex = (currentPage - 1) * itemsPerPage;
    return dataDescOrder.slice(startIndex, startIndex + itemsPerPage);
  }, [dataDescOrder, currentPage, itemsPerPage]);

  const handleNextPage = () => {
    if (currentPage < totalPages) setCurrentPage(currentPage + 1);
  };

  const handlePrevPage = () => {
    if (currentPage > 1) setCurrentPage(currentPage - 1);
  };

  const isLastPage = currentPage > 1 && currentPage === totalPages;
  // Return the paginated data and control functions
  return { paginatedData, handleNextPage, handlePrevPage, totalPages, isLastPage };
};


// Function to formate date by country (cr or usa)
export const dateFormatted = (date: string, format: string): string => {

  if (date.length < 10) {
    return "Invalid date";
  }

  if (format === "usa") {
    const day = date.slice(0, 2);
    const month = date.slice(3, 5);
    const year = date.slice(6, 10);
    return `${year}-${month}-${day}`;
  } else if (format === "cr") {
    const year = date.slice(0, 4);
    const month = date.slice(5, 7);
    const day = date.slice(8, 10);
    return `${day}-${month}-${year}`;
  } else {
    return "Invalid format";
  }
};

export const destroyActiveSession = async (idPerson: number) => {
  const session = { idPerson: idPerson, value: 0 };
  const result = await postFetch('users-persons/user-session', session);
  if (result.error) {
    return toast.error("Algo salió mal. Intentalo de nuevo.", {
      autoClose: 3000,
      theme: "dark"
    })
  };
  console.log('se destruyo la sesion')
};



