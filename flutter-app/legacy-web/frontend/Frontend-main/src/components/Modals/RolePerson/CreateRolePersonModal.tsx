import React, { useState } from "react";
import { postFetch } from "../../../utils/apiMethods";
import SelectGroupPerson from "../../Forms/SelectGroup/SelectPerson";
import SelectRole from "../../Forms/SelectGroup/SelectRole";
import { RolePerson } from "../../../interfaces/Interfaces";
import { toast } from "react-toastify";

// Defining the types for the props expects
interface CreateRolePersonProps {
  handleCloseCreateModal: () => void; // Function to close the create modal
  setRefreshData: React.Dispatch<React.SetStateAction<boolean>>;  // Function to trigger a refresh of the data after creation
  data: RolePerson[]; // All roles
}

const CreateRolePersonModal: React.FC<CreateRolePersonProps> = ({
  handleCloseCreateModal,
  setRefreshData,
  data
}) => {

  const [personId, setPersonId] = useState<number>();
  const [roleId, setRolePersonId] = useState<number>();

  // Function that handles the creation process
  const handleSaveRolePerson = async () => {
    try {
      const rolePerson = {
        roleId: roleId,
        personId: personId
      };

      //Handle error messages
      if (!roleId || !personId) {
        return toast.error("Todos los campos son obligatorios", {
          autoClose: 3000,
          theme: "dark"
        });
      } 

      if (roleId && personId && findRolePerson(roleId, personId)) {
        return toast.error("El rol ya existe", {
          autoClose: 3000,
          theme: "dark"
        })
      };
      
      // Making the API call to create
      const result = await postFetch("role-persons", rolePerson);
      
      // Error message if somethig were wrong
      if (result.error) {
        return toast.error("Algo salio mal. Intentalo de nuevo.", {
          autoClose: 3000,
          theme: "dark"
        });
      } else {
        // If no error, show a success message, close the modal, and refresh the data
        toast.success("Creado exitosamente", {
          autoClose: 3000,
          theme: "dark"
        });
        setRefreshData(true); // Trigger data refresh
        handleCloseCreateModal(); // Close the delete modal
      }
    } catch (err) {
      return toast.error("Error en el servidor. Intentalo de nuevo.", {
        autoClose: 3000,
        theme: "dark"
      });
    }
  };

  // Find if role already exists
  const findRolePerson = (idRole: number, idPerson: number) => {
    return data.some(item => {
      return item.ID_Role === idRole && item.ID_Person === idPerson;
    });
  };

  // Handle save the new person created
  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    handleSaveRolePerson();
  };

  return (
    <div className="mt-20 fixed inset-0 flex items-center justify-center bg-black bg-opacity-50">
      <div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
        <div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark flex justify-between items-center">
          <h3 className="font-medium text-black dark:text-white">
            Asignar Nuevo Rol
          </h3>
          <button onClick={handleCloseCreateModal} className="text-black dark:text-white">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
              <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
        <form onSubmit={handleSubmit} className="md:px-20">
          <div className="p-6.5 scroll-smooth">
          <div className='mb-4'>
							<SelectGroupPerson setPersonId={setPersonId} />
						</div>
            <div className='mb-8'>
            <SelectRole setRoleId={setRolePersonId} />
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

export default CreateRolePersonModal
