import React, { useState } from "react";
import { useFormik } from "formik";
import * as Yup from "yup";
import { postFetch } from "../../../utils/apiMethods";
import { Person } from "../../../interfaces/Interfaces";
import SelectCountry from "../../Forms/SelectGroup/SelectCountry";
import { toast } from "react-toastify";
import { getCurrentUser } from "../../../utils/utils";
import SelectRole from "../../Forms/SelectGroup/SelectRole";

// Defining the types for the props expects
interface CreatePersonProps {
  handleCloseCreateModal: () => void; // Function to close the create modal
  createPerson: Person; // Person to be created 
  setRefreshData: React.Dispatch<React.SetStateAction<boolean>>; // Function to trigger a refresh of the data after creation
}

const CreatePersonModal: React.FC<CreatePersonProps> = ({
  handleCloseCreateModal,
  createPerson,
  setRefreshData
}) => {
  const [countryId, setCountryId] = React.useState<number | undefined>();
  const [roleId, setRoleId] = useState<number>();
  const [loading, setLoading] = useState<boolean>(false);

  const generateRandomString = () => {
    return [...Array(8)]
      .map(() => Math.random().toString(36).charAt(2))
      .join('');
  };

  // Function that handles the creation process with formik and Yup to validate
  const formik = useFormik({
    initialValues: {
      Identify: createPerson.Identify,
      Name: createPerson.Name,
      Email: createPerson.Email,
      Tel: createPerson.Tel,
      Address: createPerson.Address,
      Username: '',
    },
    validationSchema: Yup.object({
      Identify: Yup.string()
        .max(20, 'La identificación no puede tener más de 20 carácteres')
        .required('Obligatorio'),
      Name: Yup.string().required('Obligatorio'),
      Email: Yup.string()
        .max(320, 'El correo electrónico es muy largo')
        .email('Correo no válido')
        .required('Obligatorio'),
      Tel: Yup.string()
        .matches(/^\d+$/, 'El número de teléfono debe contener solo dígitos.')
        .min(8, 'El número de teléfono debe tener al menos 8 dígitos.')
        .max(15, 'El número de teléfono debe tener como máximo 15 dígitos.')
        .required('Obligatorio'),
      Address: Yup.string().required('Obligatorio'),
      Username: Yup.string()
        .max(50, 'El nombre de usuario es muy largo')
        .required('Obligatorio'),
    }),
    onSubmit: async (values) => {
      try {
        setLoading(true);
        const user = getCurrentUser();

        if (!countryId) {
          setLoading(false);
          return toast.error("Ingresa el país", {
            autoClose: 3000,
            theme: "dark"
          })
        };

        if (!roleId) {
          setLoading(false);
          return toast.error("Selecciona un rol", {
            autoClose: 3000,
            theme: "dark"
          })
        };

        // Create person
        const person = {
          identify: values.Identify,
          name: values.Name,
          email: values.Email,
          tel: values.Tel,
          address: values.Address,
          idCountry: countryId,
        };

        const result = await postFetch("persons", person);

        if (result.duplicatedEmail) {
          setLoading(false);
          return toast.error("Este correo ya fue registrado", {
            autoClose: 3000,
            theme: "dark"
          });
        }

        if (result.duplicatedTel) {
          setLoading(false);
          return toast.error("Este numero de telefono ya fue registrado", {
            autoClose: 3000,
            theme: "dark"
          });
        }

        if (result.duplicatedIdentify) {
          setLoading(false);
          return toast.error("Esta identificación ya fue registrada", {
            autoClose: 3000,
            theme: "dark"
          })
        }

        if (result.error) {
          setLoading(false);
          return toast.error("Algo salio mal. Intentalo de nuevo.", {
            autoClose: 3000,
            theme: "dark"
          })
        }

        const pass = generateRandomString();
        const userPerson = {
          idPerson: result.idPerson,
          username: values.Username,
          password: pass,
          tempPassword: pass,
          email: result.email
        };

        const result2 = await postFetch('users-persons', userPerson);

        if (result2.usernameExists) {
          setLoading(false);
          return toast.error("El nombre de usuario ya fue registrado", {
            autoClose: 3000,
            theme: "dark"
          });
        }

        if (result2.error) {
          setLoading(false);
          return toast.error("Algo salio mal. Intentalo de nuevo.", {
            autoClose: 3000,
            theme: "dark"
          })
        }

        const validation = {
          id_validated_person: result.idPerson,
          id_validator_person: user.ID_Person
        }

        const rolePerson = {
          roleId: roleId,
          personId: result.idPerson
        }

        await postFetch('role-persons', rolePerson);

        const result3 = await postFetch('validations', validation);

        if (result3.error) {
          setLoading(false);
          return toast.error("Algo salio mal. Intentalo de nuevo.", {
            autoClose: 3000,
            theme: "dark"
          });
        } else {
          setLoading(false);
          toast.success("Creado exitosamente", {
            autoClose: 3000,
            theme: "dark"
          });
          setRefreshData(true);
          handleCloseCreateModal();
        }

      } catch (error) {
        // Error message if server failed
        setLoading(false);
        return toast.error("Algo salio mal. Intentalo de nuevo.", {
          autoClose: 3000,
          theme: "dark"
        })
      }
    }
  });

  return (
    <div className="mt-16 fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50">
      <div className="w-full max-w-xl mx-4 sm:mx-6 lg:mx-8 bg-white dark:bg-boxdark rounded-lg shadow-lg overflow-hidden max-h-screen flex flex-col">
        <div className="border-b border-stroke py-4 px-6 flex justify-between items-center dark:border-strokedark">
          <h3 className="text-lg font-semibold text-black dark:text-white">Nueva Persona</h3>
          <button onClick={handleCloseCreateModal} className="text-black dark:text-white">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
              <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
        <div className="flex-1 overflow-y-auto p-4">
          <form onSubmit={formik.handleSubmit}>
            <div className="space-y-4">
              <div className="grid grid-cols-1 gap-6 md:grid-cols-3">
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
                  <label className="mb-2 text-sm font-medium text-black dark:text-white">Nombre completo</label>
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
              <div className="flex grid grid-cols-1 gap-6 md:grid-cols-3">
                <div className="flex flex-col w-full col-span-1">
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

                <div className="flex flex-col w-full col-span-2">
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
              <div className="grid grid-cols-1 gap-6 md:grid-cols-3">
                <div className="flex flex-col">
                  <label className="mb-2 text-sm font-medium text-black dark:text-white">Nombre de Usuario</label>
                  <input
                    type="text"
                    name="Username"
                    value={formik.values.Username}
                    onChange={formik.handleChange}
                    onBlur={formik.handleBlur}
                    placeholder="Ingresa el nombre de usuario"
                    className="w-full rounded border border-stroke bg-transparent py-3 px-4 text-black outline-none transition focus:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                  />
                  {formik.touched.Username && formik.errors.Username ? (
                    <p className="text-red-500 text-sm mt-1">{formik.errors.Username}</p>
                  ) : null}
                </div>
                <div className="flex flex-col">
                  <SelectCountry setCountryId={setCountryId} />
                </div>
                <div className="flex flex-col">
                  <SelectRole setRoleId={setRoleId} />
                </div>
              </div>
              <div className="flex justify-end space-x-4">
                <button
                  type="submit"
                  className="rounded bg-primary py-2.5 px-6 text-base font-medium text-white shadow-button transition hover:opacity-80"
                  disabled={loading}
                >
                  {loading ? 'Creando...' : 'Crear'}
                </button>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default CreatePersonModal;
