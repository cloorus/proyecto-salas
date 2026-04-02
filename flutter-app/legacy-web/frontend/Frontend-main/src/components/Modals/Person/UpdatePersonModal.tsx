import React from "react";
import { useFormik } from "formik";
import * as Yup from "yup";
import { putFetch } from "../../../utils/apiMethods";
import { Person } from "../../../interfaces/Interfaces";
import SelectCountry from "../../Forms/SelectGroup/SelectCountry";
import { toast } from "react-toastify";

// Defining the types for the props expects
interface UpdatePersonProps { 
  handleCloseUpdateModal: () => void; // Function to close the update modal
  updatePerson: Person; // Person to be updated
  setRefreshData: React.Dispatch<React.SetStateAction<boolean>>; // Function to trigger a refresh of the data after update
}

const UpdatePersonModal: React.FC<UpdatePersonProps> = ({
  handleCloseUpdateModal,
  updatePerson,
  setRefreshData
}) => {
  const [countryId, setCountryId] = React.useState<number>(updatePerson.ID_Country || 0);

  // Function that handles the update process with formik and Yup to validate
  const formik = useFormik({
    initialValues: {
      Identify: updatePerson.Identify,
      Name: updatePerson.Name,
      Email: updatePerson.Email,
      Tel: updatePerson.Tel,
      Address: updatePerson.Address
    },
    validationSchema: Yup.object({
      Identify: Yup.string().required('Required'),
      Name: Yup.string().required('Required'),
      Email: Yup.string().email('Invalid email address').required('Required'),
      Tel: Yup.string()
        .matches(/^\d+$/, 'El número de teléfono debe contener solo dígitos.')
        .min(8, 'El número de teléfono debe tener al menos 8 dígitos.')
        .max(15, 'El número de teléfono debe tener como máximo 15 dígitos.')
        .required('Required'),
      Address: Yup.string().required('Required')
    }),
    onSubmit: async (values) => {
      try {
        const updatedPerson = {
          identify: values.Identify,
          name: values.Name,
          email: values.Email,
          tel: values.Tel,
          address: values.Address,
          idCountry: countryId
        };

        // Making the API call to update
        const result = await putFetch(`persons/${updatePerson.ID_Person}`, updatedPerson);

        // Handle error messages
        if (result.duplicatedEmail) {
          return toast.error("Este correo ya fue registrado", {
            autoClose: 3000,
            theme: "dark"
          });
        };

        if (result.duplicatedTel) {
          return toast.error("Este número de telefono ya fue registrado", {
            autoClose: 3000,
            theme: "dark"
          });
        };

        if (result.duplicatedIdentify) {
          return toast.error("Esta identificación ya fue registrada", {
            autoClose: 3000,
            theme: "dark"
          })
        };

        // Show generic error message 
        if (result.error) {
          return toast.error("Algo salió mal. Intentalo de nuevo.", {
            autoClose: 3000,
            theme: "dark"
          });
        } else {
          // If no error, show a success message, close the modal, and refresh the data
          toast.success("Editado exitosamente", {
            autoClose: 3000,
            theme: "dark"
          });
					setRefreshData(true); // Trigger data refresh
					handleCloseUpdateModal(); // Close the update modal
        }
      } catch (err) {
        // Error message if server failed
        return toast.error("Error en el servidor. Intentalo de nuevo.", {
          autoClose: 3000,
          theme: "dark"
        });
      }
    }
  });

  return (
    <div className="mt-20 fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50">
      <div className="w-full max-w-lg mx-4 sm:mx-6 lg:mx-8 bg-white dark:bg-boxdark rounded-lg shadow-lg overflow-hidden">
        <div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark flex justify-between items-center">
          <h3 className="font-medium text-black dark:text-white">Editar Persona</h3>
          <button onClick={handleCloseUpdateModal} className="text-black dark:text-white">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
              <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
        <form onSubmit={formik.handleSubmit} className="p-6">
          <div className="space-y-6">
            <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
              <div className="flex flex-col">
                <label className="mb-2 text-sm font-medium text-black dark:text-white">Identificación</label>
                <input
                  type="text"
                  name="Identify"
                  value={formik.values.Identify}
                  onChange={formik.handleChange}
                  onBlur={formik.handleBlur}
                  placeholder="Ingresa la identificación"
                  className="w-full rounded border border-stroke bg-transparent py-3 px-4 text-black outline-none transition focus:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                />
                {formik.touched.Identify && formik.errors.Identify ? (
                  <p className="text-red-500 text-sm mt-1">{formik.errors.Identify}</p>
                ) : null}
              </div>
              <div className="flex flex-col">
                <label className="mb-2 text-sm font-medium text-black dark:text-white">Nombre</label>
                <input
                  type="text"
                  name="Name"
                  value={formik.values.Name}
                  onChange={formik.handleChange}
                  onBlur={formik.handleBlur}
                  placeholder="Ingresa el nombre"
                  className="w-full rounded border border-stroke bg-transparent py-3 px-4 text-black outline-none transition focus:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                />
                {formik.touched.Name && formik.errors.Name ? (
                  <p className="text-red-500 text-sm mt-1">{formik.errors.Name}</p>
                ) : null}
              </div>
            </div>
            <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
              <div className="flex flex-col">
                <label className="mb-2 text-sm font-medium text-black dark:text-white">Email</label>
                <input
                  type="text"
                  name="Email"
                  value={formik.values.Email}
                  onChange={formik.handleChange}
                  onBlur={formik.handleBlur}
                  placeholder="Ingresa el email"
                  className="w-full rounded border border-stroke bg-transparent py-3 px-4 text-black outline-none transition focus:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                />
                {formik.touched.Email && formik.errors.Email ? (
                  <p className="text-red-500 text-sm mt-1">{formik.errors.Email}</p>
                ) : null}
              </div>
              <div className="flex flex-col">
                <label className="mb-2 text-sm font-medium text-black dark:text-white">Teléfono</label>
                <input
                  type="text"
                  name="Tel"
                  value={formik.values.Tel}
                  onChange={formik.handleChange}
                  onBlur={formik.handleBlur}
                  placeholder="Ingresa el teléfono"
                  className="w-full rounded border border-stroke bg-transparent py-3 px-4 text-black outline-none transition focus:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                />
                {formik.touched.Tel && formik.errors.Tel ? (
                  <p className="text-red-500 text-sm mt-1">{formik.errors.Tel}</p>
                ) : null}
              </div>
            </div>
            <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
              <div className="flex flex-col">
                <SelectCountry currentCountry={updatePerson.ID_Country} setCountryId={setCountryId} />
              </div>
              <div className="flex flex-col">
                <label className="mb-2 text-sm font-medium text-black dark:text-white">Dirección</label>
                <input
                  type="text"
                  name="Address"
                  value={formik.values.Address}
                  onChange={formik.handleChange}
                  onBlur={formik.handleBlur}
                  placeholder="Ingresa la dirección"
                  className="w-full rounded border border-stroke bg-transparent py-3 px-4 text-black outline-none transition focus:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                />
                {formik.touched.Address && formik.errors.Address ? (
                  <p className="text-red-500 text-sm mt-1">{formik.errors.Address}</p>
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

export default UpdatePersonModal;
