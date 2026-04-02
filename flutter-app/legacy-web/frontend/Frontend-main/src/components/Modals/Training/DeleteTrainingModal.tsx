import React from "react";
import { deleteFetch } from "../../../utils/apiMethods";
import { toast } from "react-toastify";

// Defining the types for the props expects
interface DeletePersonProps {
    handleCloseDeleteModal: () => void; // Function to close the delete modal
    deleteTrainingId: number | undefined; // ID to be deleted  
    setRefreshData: React.Dispatch<React.SetStateAction<boolean>>; // Function to trigger a refresh of the data after deletion
}

const  DeleteTrainingModal: React.FC<DeletePersonProps> = ({
    handleCloseDeleteModal,
    deleteTrainingId,
    setRefreshData
}) => {

  // Function that handles the deletion process
    const handleDeleteTraining = async () => {
        try {
            // Making the API call to delete by its ID
            const result = await deleteFetch(`trainings/${deleteTrainingId}`);

            // Error message if somethig were wrong
            if (result.error) {
              return toast.error('Algo salió mal. Intentalo de nuevo.',{
                autoClose: 3000,
                theme: "dark"
              });
            } else {
              // If no error, show a success message, close the modal, and refresh the data
              toast.success('Eliminado exitosamente',{
                autoClose: 3000,
                theme: "dark"
              });
              setRefreshData(true); // Trigger data refresh
              handleCloseDeleteModal(); // Close the delete modal
            }
        } catch (err) {
          // Error message if server failed
          return toast.error('Algo salió mal. Intentalo de nuevo.',{
            autoClose: 3000,
            theme: "dark"
          });
        }
    };

    return (
        <div className="mt-20 fixed inset-0 flex items-center justify-center bg-black bg-opacity-50">
        <div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
          <div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark flex justify-between items-center">
            <h3 className="font-medium text-black dark:text-white">Eliminar Persona</h3>
            <button onClick={handleCloseDeleteModal} className="text-black dark:text-white">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
                <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          <div className="p-6.5">
            <p className="text-black dark:text-white">¿Estás seguro de que deseas eliminar?</p>
          </div>
          <div className="flex justify-center border-t border-stroke p-6.5 dark:border-strokedark">
            <button onClick={() => handleDeleteTraining()} type="button" className="rounded bg-danger py-2.5 px-6 text-base font-medium text-white shadow-button transition hover:opacity-80">
              Eliminar
            </button>
            <button onClick={handleCloseDeleteModal} type="button" className="ml-4 rounded bg-graydark py-2.5 px-6 text-base font-medium text-white shadow-button transition hover:opacity-80">
              Cancelar
            </button>
          </div>
        </div>
      </div>
    )
}

export default DeleteTrainingModal;