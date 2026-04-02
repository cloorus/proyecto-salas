import { useState } from "react";
import Breadcrumb from "../Breadcrumbs/Breadcrumb";
import { postFetch, putFetch } from "../../utils/apiMethods";
import { getCurrentUser } from "../../utils/utils";
import { toast } from "react-toastify";

interface ResetPasswordProps {
    handleLogout: () => void;
}

const ResetPassword: React.FC<ResetPasswordProps> = ({ handleLogout }) => {
    // State management for password visibility and input values
    const [showPassword, setShowPassword] = useState<boolean>();
    const [showPassword2, setShowPassword2] = useState<boolean>();
    const [showPassword3, setShowPassword3] = useState<boolean>();
    const [showRestPassword, setShowRestPassword] = useState<boolean>(false);
    const [showInputRestPassword, setShowInputRestPassword] = useState<boolean>(false);
    const [code, setCode] = useState<string>('');
    const [oldPassword, setOldPassword] = useState<string>('');
    const [newPass, setNewPass] = useState<string>('');
    const [newPass2, setNewPass2] = useState<string>('');
    const [generatedCode, setGeneratedCode] = useState<string>('');
    const [isCodeMatch, setIsCodeMatch] = useState<boolean>(false);

    // Get the current user information
    const user = getCurrentUser();

    // Function to handle password reset submission
    const handleResetPassword = async () => {
        try {
            if (newPass !== newPass2) {
                return toast.error("Las contraseñas no coinciden", {
                    autoClose: 3000,
                    theme: "dark"
                });
            }
            const newPassword = {
                username: user.Username,
                oldPassword: oldPassword,
                newPassword: newPass,
                tempPassword: null,
            };

            // API call to update password
            const result = await putFetch(`users-persons/${user.ID_Person}`, newPassword);
            if (result.error) {
                return toast.error("Algo salió mal", {
                    autoClose: 3000,
                    theme: "dark"
                });
            } else {
                // Success feedback and automatic logout after successful password change
                toast.success("La contraseña se cambió exitosamente. Inicia sesión con la nueva contraseña.", {
                    autoClose: 3000,
                    theme: "dark",
                });
                setTimeout(() => {
                    handleLogout();
                }, 3000);
            }
        } catch (error) {
            console.log(error);
        }
    };

    // Helper function to generate a random string (for reset code)
    const generateRandomString = () => {
        return [...Array(8)]
            .map(() => Math.random().toString(36).charAt(2))
            .join('');
    };

    // Function to handle requesting a reset code
    const handleRequestCode = async () => {
        try {
            const resetPassword = {
                username: user.Username,
                email: user.Email,
                tempPassword: generateRandomString()
            }

             // API call to send reset code
            const result = await postFetch('users-persons/send-code', resetPassword);
            if (result.error) {
                return toast.error("Algo salio mal. Intentalo de nuevo.", {
                    autoClose: 3000,
                    theme: "dark"
                });
            } else {
               // Success feedback, showing input for code, and storing generated code 
                toast.success(`El código se envió al correo: ${user.Email}`, {
                    autoClose: 3000,
                    theme: "dark"
                });
                setGeneratedCode(result.generatedCode)
                setShowInputRestPassword(true); // Show input field for entering the code
            }
        } catch (error) {
            console.log(error);
        }
    };

    // Function to handle code matching process
    const handleCodeMatch = async () => {
        console.log(code, generatedCode)
        if (code !== generatedCode) {
            return toast.error('El codigo ingresado no es correcto', {
                autoClose: 3000,
                theme: "dark"
            });
        } else {
            const codePassword = { tempPassword: generatedCode }

            // API call to update temporal password based on correct code
            const result = await putFetch(`users-persons/temp-password/${user.ID_Person}`, codePassword);
            if (result.error) {
                return toast.error('Algo salio mal', {
                    autoClose: 3000,
                    theme: "dark"
                });
            } else {
                // Update UI to allow resetting password after successful code verification
                setShowRestPassword(false);
                setIsCodeMatch(true);
                setOldPassword(generatedCode); // Set old password to the generated code for verification
                toast.success('Codigo correcto', {
                    autoClose: 3000,
                    theme: "dark"
                })
            }
        }
    };

    return (
        <>
            <Breadcrumb pageName="Cambiar contraseña" />
            <div className="flex justify-center">
                {showRestPassword ? (
                    <div className="w-2/5 rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
                        <div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark">
                            <h3 className="font-medium text-black dark:text-white">
                                Código para solicitar nueva contraseña
                            </h3>
                        </div>
                        <div className="flex flex-col gap-5.5 py-10 px-20">
                            {showInputRestPassword && (
                                <div>
                                    <label className="mb-3 block text-black dark:text-white">
                                        Ingresa el código
                                    </label>
                                    <input
                                        type="text"
                                        value={code}
                                        onChange={(e) => setCode(e.target.value)}
                                        placeholder="Ingresa el código que se envió al correo"
                                        className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                                    />
                                </div>
                            )}
                            {!showInputRestPassword && (
                                <div className="flex justify-center dark:border-strokedark space-x-4">
                                    <button
                                        onClick={() => setShowRestPassword(false)}
                                        className="rounded bg-graydark py-2.5 px-6 text-base font-medium text-white shadow-button transition hover:opacity-80"
                                    >
                                        Regresar
                                    </button>

                                    <button
                                        onClick={handleRequestCode}
                                        className="rounded bg-warning py-2.5 px-6 text-base font-medium text-white shadow-button transition hover:opacity-80"
                                    >
                                        Solicitar código
                                    </button>
                                </div>
                            )}
                            {showInputRestPassword && (
                                <div className="flex justify-end border-t border-stroke py-6 dark:border-strokedark">
                                    <button
                                        onClick={handleCodeMatch}
                                        className="rounded bg-primary py-2.5 px-6 text-base font-medium text-white shadow-button transition hover:opacity-80"
                                    >
                                        Siguiente
                                    </button>
                                </div>
                            )}
                        </div>
                    </div>
                ) : (
                    <div className="w-2/5 rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
                        <div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark">
                            <h3 className="font-medium text-black dark:text-white">
                                Nueva contraseña
                            </h3>
                        </div>
                        <div className="flex flex-col gap-5.5 py-10 px-20">
                            {!isCodeMatch &&
                                <div className="relative">
                                    <label className="mb-3 block text-black dark:text-white">
                                        Ingrese la contraseña actual
                                    </label>
                                    <input
                                        type={showPassword ? "text" : "password"}
                                        value={oldPassword}
                                        onChange={(e) => setOldPassword(e.target.value)}
                                        placeholder="Ingresa la nueva contraseña"
                                        className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 pl-5 pr-12  text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                                    />
                                    <span onClick={() => setShowPassword(!showPassword)} className="absolute right-4 bottom-3.5">
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
                            }
                            <div className="relative">
                                <label className="mb-3 block text-black dark:text-white">
                                    Ingresa la contraseña nueva
                                </label>
                                <input
                                    type={showPassword2 ? "text" : "password"}
                                    value={newPass}
                                    onChange={(e) => setNewPass(e.target.value)}
                                    placeholder="Ingresa la nueva contraseña"
                                    className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 pl-5 pr-12 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                                />
                                <span onClick={() => setShowPassword2(!showPassword2)} className="absolute right-4 bottom-3.5">
                                    {showPassword2 ? (
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
                            <div className="relative">
                                <label className="mb-3 block text-black dark:text-white">
                                    Ingresa nuevamente la contraseña nueva
                                </label>
                                <input
                                    type={showPassword3 ? "text" : "password"}
                                    value={newPass2}
                                    onChange={(e) => setNewPass2(e.target.value)}
                                    placeholder="Ingresa la nueva contraseña"
                                    className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 pl-5 pr-12 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                                />
                                <span onClick={() => setShowPassword3(!showPassword3)} className="absolute right-4 bottom-3.5">
                                    {showPassword3 ? (
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
                            <div>
                                <button onClick={() => setShowRestPassword(true)}>
                                    <a className="underline">¿Olvidaste la contraseña?</a>
                                </button>
                            </div>
                            <div className="flex justify-end border-t border-stroke py-6 dark:border-strokedark">
                                <button
                                    onClick={handleResetPassword}
                                    className="rounded bg-primary py-2.5 px-6 text-base font-medium text-white shadow-button transition hover:opacity-80"
                                >
                                    Enviar
                                </button>
                            </div>
                        </div>
                    </div>
                )}
            </div>
        </>
    );
};

export default ResetPassword;
