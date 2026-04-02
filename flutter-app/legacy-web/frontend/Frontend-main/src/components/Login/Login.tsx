import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import LogoDark from '../../images/logo/logo-salas-dark.png';
import Logo from '../../images/logo/logo-salas.png';
import { useFormik } from 'formik';
import * as Yup from "yup";
import { postFetch } from '../../utils/apiMethods';
import { toast } from 'react-toastify';
import { UserLogin } from '../../interfaces/Interfaces';

// Defining the types for the props expects
interface LoginProps {
  handleLogin: (user: UserLogin) => void;
}

const Login: React.FC<LoginProps> = ({ handleLogin }) => {

  const [showPassword, setShowPassword] = useState<boolean>(false);
  const navigate = useNavigate();

  // Function that handles the login process with formik and Yup to validate
  const formik = useFormik({
    initialValues: {
      Username: '',
      Password: ''
    },
    validationSchema: Yup.object({
      Username: Yup.string().required('Obligatorio'),
      Password: Yup.string().required('Obligatorio')
    }),
    onSubmit: async (values) => {
      try {
        const login = {
          username: values.Username,
          password: values.Password
        };

        // Making the API call to update
        const result = await postFetch(`users-persons/auth`, login);

        //Set the logged person to storage
        const loggedPerson: UserLogin = {
          Username: login.username,
          ID_Person: result.idPerson,
          ID_Role: result.role,
          Email: result.email
        }

        // Handle error messages
        if (result.error) {
          // Error message if there is active session in another device
          if (result.activeSession) {
            return toast.error("Tienes una sesion activa en otro dispositivo", {
              autoClose: 3000,
              theme: "dark"
            })
          };

          // Error message if the credentials are invalid
          return toast.error("Credenciales inválidas", {
            autoClose: 3000,
            theme: "dark"
          })
          // Redirect to reset password page is user has temporal password
        } else if (result.hasTempPassword) {
          alert("Cambia la contraseña")
          handleLogin(loggedPerson as UserLogin);
          navigate("/reset-password")
        } else {
           // Redirect to home page
          handleLogin(loggedPerson as UserLogin);
          navigate("/")
        };

      } catch (err) {
        console.error("Error on login", err);
      };
    }
  });

  // Function to show or hide password
  const handleShowPassword = () => {
    setShowPassword(!showPassword);
  }

  return (
    <>
      <div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
        <div className="flex flex-wrap items-center">
          <div className="hidden w-full xl:block xl:w-1/2">
            <div className="py-17.5 px-26 text-center">
              <Link className="mb-5.5 inline-block" to="/">
                <img className="hidden dark:block" src={Logo} alt="Logo" />
                <img className="dark:hidden" src={LogoDark} alt="Logo" />
              </Link>
            </div>
          </div>

          <div className="w-full border-stroke dark:border-strokedark xl:w-1/2 xl:border-l-2">
            <div className="w-full h-screen p-4 sm:p-12.5 xl:p-17.5">
              <span className="mb-1.5 block font-medium">Portones Salas</span>
              <h2 className="mb-9 text-2xl font-bold text-black dark:text-white sm:text-title-xl2">
                Ingreso al sistema
              </h2>
              <form onSubmit={formik.handleSubmit}>
                <div className="mb-4">
                  <label className="mb-2.5 block font-medium text-black dark:text-white">
                    Nombre de usuario
                  </label>
                  <div className="relative">
                    <input
                      type="text"
                      name="Username"
                      value={formik.values.Username}
                      onChange={formik.handleChange}
                      onBlur={formik.handleBlur}
                      placeholder="Ingresa el nombre de usuario"
                      className="w-full rounded-lg border border-stroke bg-transparent py-4 pl-6 pr-10 text-black outline-none focus:border-primary focus-visible:shadow-none dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                    />
                    {formik.touched.Username && formik.errors.Username ? (
                      <p className="text-red-500 text-sm mt-1">{formik.errors.Username}</p>
                    ) : null}
                    <span className="absolute right-4 top-4">
                      <svg xmlns="http://www.w3.org/2000/svg" opacity="0.5" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="size-6">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M17.982 18.725A7.488 7.488 0 0 0 12 15.75a7.488 7.488 0 0 0-5.982 2.975m11.963 0a9 9 0 1 0-11.963 0m11.963 0A8.966 8.966 0 0 1 12 21a8.966 8.966 0 0 1-5.982-2.275M15 9.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" />
                      </svg>

                    </span>
                  </div>
                </div>

                <div className="mb-6">
                  <label className="mb-2.5 block font-medium text-black dark:text-white">
                    Contraseña
                  </label>
                  <div className="relative">
                    <input
                      type={showPassword ? "text" : "password"}
                      name="Password"
                      value={formik.values.Password}
                      onChange={formik.handleChange}
                      onBlur={formik.handleBlur}
                      placeholder="Ingresa la contraseña"
                      className="w-full rounded-lg border border-stroke bg-transparent py-4 pl-6 pr-10 text-black outline-none focus:border-primary focus-visible:shadow-none dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                    />
                    {formik.touched.Password && formik.errors.Password ? (
                      <p className="text-red-500 text-sm mt-1">{formik.errors.Password}</p>
                    ) : null}
                    <span onClick={handleShowPassword} className="absolute right-4 top-4">
                      {showPassword ? (
                        <svg xmlns="http://www.w3.org/2000/svg" opacity="0.5" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="size-6">
                          <path strokeLinecap="round" strokeLinejoin="round" d="M13.5 10.5V6.75a4.5 4.5 0 1 1 9 0v3.75M3.75 21.75h10.5a2.25 2.25 0 0 0 2.25-2.25v-6.75a2.25 2.25 0 0 0-2.25-2.25H3.75a2.25 2.25 0 0 0-2.25 2.25v6.75a2.25 2.25 0 0 0 2.25 2.25Z" />
                        </svg>
                      ) : (
                        <svg xmlns="http://www.w3.org/2000/svg" opacity="0.5" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="size-6">
                          <path strokeLinecap="round" strokeLinejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 1 0-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 0 0 2.25-2.25v-6.75a2.25 2.25 0 0 0-2.25-2.25H6.75a2.25 2.25 0 0 0-2.25 2.25v6.75a2.25 2.25 0 0 0 2.25 2.25Z" />
                        </svg>
                      )}
                    </span>
                  </div>
                </div>
                <div className="mb-5">
                  <input
                    disabled={formik.isSubmitting || !formik.isValid}
                    type="submit"
                    value="Ingresar"
                    className="w-full cursor-pointer rounded-lg border border-primary bg-primary p-4 text-white transition hover:bg-opacity-90"
                  />
                </div>
                <div>
                  <button onClick={() => navigate('/reset-password-user')}>
                    <span className='underline'>
                      ¿Olvidateste la contraseña?
                    </span>
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default Login;
