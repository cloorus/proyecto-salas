import React, { useState } from "react";
import { putFetch } from "../../../utils/apiMethods";
import SelectRole from "../../Forms/SelectGroup/SelectRole";
import { RolePerson } from "../../../interfaces/Interfaces";
import { toast } from "react-toastify";

// Defining the types for the props expects
interface UpdateRolePersonProps { 
  handleCloseUpdateModal: () => void; // Function to close the update modal
  editRolePerson: RolePerson; // Role Person to be updated
  setRefreshData: React.Dispatch<React.SetStateAction<boolean>>; // Function to trigger a refresh of the data after update
  data: RolePerson[] // All roles persons 
}

const UpdateRolePersonModal: React.FC<UpdateRolePersonProps> = ({
  handleCloseUpdateModal,
  editRolePerson,
  setRefreshData,
  data
}) => {

  const [roleId, setRoleId] = useState<number>(editRolePerson.ID_Role || 0);
  const personId = editRolePerson.ID_Person;

  const handleUpdateRolePerson = async () => {
    const updatedRolePerson = { roleId: roleId };
    try {

      // Verify if role already exists
      const roleExists = roleId && personId && findRolePerson(roleId, personId);
      if (roleExists && roleId !== editRolePerson.ID_Role) {
        toast.error("El rol ya existe", {
          autoClose: 3000,
          theme: "dark"
        });
        return;
      };

      // Making the API call to update
      const result = await putFetch(`role-persons/${editRolePerson.ID_Role_Person}`, updatedRolePerson);
      
      // Generic error message
      if (result.error) {
        return toast.error("Algo salió mal. Intentalo de nuevo.",{
          autoClose: 3000,
          theme: "dark"
        });	
      } else {
        // If no error, show a success message, close the modal, and refresh the data
        toast.success("Editado existosamente",{
          autoClose: 3000,
          theme: "dark"
        });	
        setRefreshData(true); // Trigger data refresh
        handleCloseUpdateModal(); // Close the update modal
      }
    } catch (err) {
      
      return toast.error("Error en el servidor. Intentalo de nuevo.",{
        autoClose: 3000,
        theme: "dark"
      });	
    }
  };

  // Function that verify if role person already exists
  const findRolePerson = (idRole: number, idPerson: number) => {
    return data.some(item => {
      console.log(item);
      return item.ID_Role === idRole && item.ID_Person === idPerson;
    });
  };

  // Send the updated role person
  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    handleUpdateRolePerson();
  };

  return (
    <div className="mt-20 fixed inset-0 flex items-center justify-center bg-black bg-opacity-50">
      <div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
        <div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark flex justify-between items-center">
          <h3 className="font-medium text-black dark:text-white">
            Editar Rol Asignado
          </h3>
          <button onClick={handleCloseUpdateModal} className="text-black dark:text-white">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
              <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
        <form onSubmit={handleSubmit}>
          <div className="p-6.5 scroll-smooth">
            <div className="mb-4.5 flex flex-col gap-6 xl:flex-row">
              <div className="w-full xl:w-1/2">
                <label className="mb-2.5 block text-black dark:text-white">
                  Persona
                </label>
                <div className='mt-6'>
                  <label className='w-full border-stroke bg-transparent text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary'>
                    {editRolePerson.Name}
                  </label>
                </div>

              </div>
              <SelectRole currentRole={editRolePerson.Role} setRoleId={setRoleId} />
            </div>
            <button
              type="submit"
              className="flex w-full justify-center rounded bg-primary p-3 font-medium text-gray hover:bg-opacity-90"
            >
              Enviar
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default UpdateRolePersonModal;
