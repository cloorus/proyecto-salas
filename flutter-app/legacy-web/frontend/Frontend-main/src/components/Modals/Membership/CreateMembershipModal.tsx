import React, { useState } from "react";
import { useFormik } from "formik";
import * as Yup from "yup";
import { postFetch } from "../../../utils/apiMethods";
import { Membership } from "../../../interfaces/Interfaces";
import DatePickerOne from "../../Forms/DatePicker/DatePickerOne";
import SelectGroupPerson from "../../Forms/SelectGroup/SelectPerson";
import { toast } from "react-toastify";

// Defining the types for the props expects
interface CreateMembershipProps {
  handleCloseCreateModal: () => void; // Function to close the create modal
  createMembership: Membership; // Membership to be created 
  setRefreshData: React.Dispatch<React.SetStateAction<boolean>>; // Function to trigger a refresh of the data after creation
}

const CreateMembershipModal: React.FC<CreateMembershipProps> = ({
  handleCloseCreateModal,
  setRefreshData
}) => {

  const [personId, setPersonId] = useState<number>();
  const [datePayment, setDatePayment] = useState<string>();

  // Function to set the expiration date for a membership (valid for one year from the given date)
  const dateExpiration = (datePayment: string) => {
    const [year, month, day] = datePayment.split('-');
    const newYear = (parseInt(year) + 1).toString();
    const dateExp = `${newYear}-${month}-${day}`;
    return dateExp;
  };

  // Function that handles the creation process with formik and Yup to validate
  const formik = useFormik({
    initialValues: {
      Type: ''
    },
    validationSchema: Yup.object({
      Type: Yup.string().required('Obligatorio')
    }),
    onSubmit: async (values) => {
      try {
        const membership = {
          idPerson: personId,
          datePayment: datePayment,
          dateExpiration: dateExpiration(datePayment ? datePayment : ''),
          type: values.Type
        };

        // Making the API call to create
        const result = await postFetch("memberships", membership);

        // Error message if somethig were wrong
        if (result.error) {
          return toast.error('Algo salio mal. Intentalo de nuevo.',{
            autoClose: 3000,
            theme: "dark"
          });
        } else {
          // If no error, show a success message, close the modal, and refresh the data
          toast.success('Creado exitosamente',{
            autoClose: 3000,
            theme: "dark"
          });
					setRefreshData(true); // Trigger data refresh
					handleCloseCreateModal(); // Close the delete modal
        }
      } catch (err) {
        // Error message if server failed
        return toast.error('Error en el servidor. Intentalo de nuevo.',{
          autoClose: 3000,
          theme: "dark"
        });
      }
    }
  });

  return (
    <div className="mt-20 fixed inset-0 flex items-center justify-center bg-black bg-opacity-50">
      <div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
        <div className="border-b border-stroke py-4 px-6 flex justify-between items-center dark:border-strokedark">
          <h3 className="text-lg font-semibold text-black dark:text-white">Nueva Membresía</h3>
          <button onClick={handleCloseCreateModal} className="text-black dark:text-white">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
              <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
        <form onSubmit={formik.handleSubmit} className="p-6">
          <div className="p-6 scroll-smooth">
            <div className="mb-4 flex flex-col gap-6 xl:flex-row">
              <div className="w-full xl:w-1/2">
                <SelectGroupPerson setPersonId={setPersonId} />
              </div>
              <div className="w-full xl:w-1/2">
                <label className="mb-1 block text-black dark:text-white">Fecha de pago</label>
                <DatePickerOne setDate={setDatePayment} />
              </div>
            </div>
            <div className="mb-4 flex flex-col gap-6 xl:flex-row">
              <div className="w-full xl:w-1/2">
                <label className="mb-2 block text-black dark:text-white">Tipo</label>
                <input
                  type="text"
                  name="Type"
                  value={formik.values.Type}
                  onChange={formik.handleChange}
                  onBlur={formik.handleBlur}
                  placeholder="Ingresa el tipo"
                  className="w-full rounded border border-stroke bg-transparent py-3 px-4 text-black outline-none transition focus:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                />
                {formik.touched.Type && formik.errors.Type ? (
                  <p className="text-red-500 text-sm mt-1">{formik.errors.Type}</p>
                ) : null}
              </div>
            </div>
          </div>
          <div className="flex justify-end border-t border-stroke p-6 dark:border-strokedark">
            <button
              type="submit"
              className="rounded bg-primary py-2.5 px-6 text-base font-medium text-white shadow-button transition hover:opacity-80"
              disabled={formik.isSubmitting || !formik.isValid}
            >
              Guardar
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default CreateMembershipModal;
