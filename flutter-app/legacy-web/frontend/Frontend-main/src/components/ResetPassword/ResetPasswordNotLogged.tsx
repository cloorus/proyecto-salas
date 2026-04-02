import { useState } from "react";
import { postFetch, putFetch } from "../../utils/apiMethods";
import { toast } from "react-toastify";
import { Formik, Form, Field } from 'formik';
import * as Yup from 'yup';
import { useNavigate } from "react-router-dom";

// Creating Yup schema for form validation
const ResetPasswordSchema = Yup.object().shape({
    username: Yup.string().required('Obligatorio'),
    email: Yup.string().email('Correo electrónico no válido').required('Obligatorio'),
    code: Yup.string(),
});

const ResetPasswordNotLogged = () => {
    // State management for password visibility and input values
    const [idPerson, setIdPerson] = useState<number>();
    const [showInputCode, setShowInputCode] = useState<boolean>(false);
    const [generatedCode, setGeneratedCode] = useState<string>('');
    const [code, setCode] = useState<string>(''); // Added code state

    // Using the navigate function to redirect users to other pages
    const navigate = useNavigate();

    // Helper function to generate a random string (for reset code)
    const generateRandomString = () => {
        return [...Array(8)]
            .map(() => Math.random().toString(36).charAt(2))
            .join('');
    };

    // Function to handle the request for a reset code
    const handleRequestCode = async (values: any) => {
        try {
            const resetPassword = {
                username: values.username,
                email: values.email,
                tempPassword: generateRandomString()
            };
            const result = await postFetch('users-persons/send-code', resetPassword);
            if (result.error) {
                if (result.userNotFound) {
                    // If user is not found, show an error message
                    return toast.error("El nombre de usuario no existe", {
                        autoClose: 3000,
                        theme: "dark"
                    });
                } else if (result.emailNotFound) {
                    // If email is not found, show an error message
                    return toast.error("El correo electrónico no existe", {
                        autoClose: 3000,
                        theme: "dark"
                    });
                }
                 // Generic error message
                return toast.error("Algo salió mal. Inténtalo de nuevo.", {
                    autoClose: 3000,
                    theme: "dark"
                });
            } else {
                // Successfully sent the code, updating state
                setIdPerson(result.idPerson);
                setGeneratedCode(result.generatedCode);
                setShowInputCode(true); 
                return toast.success(`El código se envió al correo: ${values.email}`, {
                    autoClose: 3000,
                    theme: "dark"
                });
            }
        } catch (error) {
            console.log(error);
        }
    };

    // Function to handle code matching for resetting the password
    const handleCodeMatch = async () => {
        if (code !== generatedCode) {
            // If the code entered does not match, show an error
            return toast.error('El código ingresado no es correcto', {
                autoClose: 3000,
                theme: "dark"
            });
        } else {
             // Code matches, proceed to update the password
            const codePassword = { tempPassword: generatedCode };
            const result = await putFetch(`users-persons/temp-password/${idPerson}`, codePassword);
            if (result.error) {
                // If there's an error updating the password, show an error message
                return toast.error('Algo salió mal', {
                    autoClose: 3000,
                    theme: "dark"
                });
            } else {
                //Password reset successful, prompt user to log in with new temporary password
                toast.success('Código correcto. Inicia sesion con la clave temporal.', {
                    autoClose: 3000,
                    theme: "dark"
                });
                return navigate('/');  // Redirecting the user to the login page
            }
        }
    };

    return (
        <div className="my-10">
            <div className="flex justify-center">
                <div className="w-2/5 rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
                    <div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark">
                        <h3 className="font-medium text-black dark:text-white">
                            Código para solicitar nueva contraseña
                        </h3>
                    </div>
                    <Formik
                        initialValues={{
                            username: '',
                            email: '',
                            code: ''
                        }}
                        validationSchema={ResetPasswordSchema}
                        onSubmit={(values) => {
                        if (!showInputCode) {
                                // If the code input is not shown, request the code
                                handleRequestCode(values);
                            } else {
                                // If the code input is shown, validate the code
                                handleCodeMatch();
                            }
                        }}
                    >
                        {({ errors, touched }) => (
                            <Form className="flex flex-col gap-5.5 pt-5 px-10">
                                {!showInputCode ? (
                                    <>
                                        <label className="block text-black dark:text-white">Ingrese su nombre de usuario</label>
                                        <Field
                                            name="username"
                                            placeholder="Nombre de usuario"
                                            className="rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-2 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                                        />
                                        {errors.username && touched.username ? (
                                            <div className="text-red-500">{errors.username}</div>
                                        ) : null}

                                        <label className="block text-black dark:text-white">Ingrese su correo electrónico</label>
                                        <Field
                                            name="email"
                                            type="email"
                                            placeholder="Correo electrónico"
                                            className="rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-2 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                                        />
                                        {errors.email && touched.email ? (
                                            <div className="text-red-500">{errors.email}</div>
                                        ) : null}

                                        <div className="flex justify-center dark:border-strokedark space-x-4 pb-5">
                                            <button
                                                type="button"
                                                onClick={() => navigate('/')}
                                                className="rounded bg-graydark py-2.5 px-6 text-base font-medium text-white shadow-button transition hover:opacity-80"
                                            >
                                                Regresar
                                            </button>
                                            <button
                                                type="submit"
                                                className="rounded bg-warning py-2.5 px-6 text-base font-medium text-white shadow-button transition hover:opacity-80"
                                            >
                                                Solicitar código
                                            </button>
                                        </div>
                                    </>
                                ) : (
                                    <div>
                                        <label className="mb-3 block text-black dark:text-white">Ingresa el código</label>
                                        <input
                                            type="text"
                                            value={code}
                                            onChange={(e) => setCode(e.target.value)}
                                            placeholder="Ingresa el código que se envió al correo"
                                            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                                        />
                                        <div className="flex justify-center dark:border-strokedark space-x-4 pb-5">
                                            <button
                                                type="submit"
                                                className="my-4 rounded bg-warning py-2.5 px-6 text-base font-medium text-white shadow-button transition hover:opacity-80"
                                            >
                                                Validar código
                                            </button>
                                        </div>
                                    </div>
                                )}
                            </Form>
                        )}
                    </Formik>
                </div>
            </div>
        </div>
    );
};

export default ResetPasswordNotLogged;
