import React from "react";
import { putFetch } from "../../../utils/apiMethods";
import { Country } from "../../../interfaces/Interfaces";
import { useFormik } from "formik";
import * as Yup from "yup";
import { toast } from "react-toastify";

// Defining the types for the props expects
interface UpdateCountryProps {
	handleCloseUpdateModal: () => void; // Function to close the update modal
	updateCountry: Country; // Country to be updated
	setRefreshData: React.Dispatch<React.SetStateAction<boolean>>; // Function to trigger a refresh of the data after update
}

const UpdateCountryModal: React.FC<UpdateCountryProps> = ({
	handleCloseUpdateModal,
	updateCountry,
	setRefreshData
}) => {

	// Function that handles the update process with formik and Yup to validate
	const formik = useFormik({
		initialValues: {
			Name: updateCountry.Name,
			CodReg: updateCountry.Cod_Reg
		},
		validationSchema: Yup.object({
			Name: Yup.string().required('Obligatorio'),
			CodReg: Yup.string()
				.max(5, 'El código de región debe tener como máximo 5 digitos')
				.required('Obligatorio')
		}),
		onSubmit: async (values) => {
			try {
				const country = {
					name: values.Name,
					cod_reg: values.CodReg
				};

				// Making the API call to update
				const result = await putFetch(`countries/${updateCountry.ID_Country}`, country);

				// Error message if somethig were wrong
				if (result.error) {
					return toast.error('Algo salio mal. Intentalo de nuevo', {
						autoClose: 3000,
						theme: "dark"
					});
				} else {
					// If no error, show a success message, close the modal, and refresh the data
					toast.success('Actualizado exitosamente', {
						autoClose: 3000,
						theme: "dark"
					});
					setRefreshData(true); // Trigger data refresh
					handleCloseUpdateModal(); // Close the update modal
				}
			} catch (err) {
				return toast.error('Error en el servidor. Intentalo de nuevo', {
					autoClose: 3000,
					theme: "dark"
				});
			};
		}
	});

	return (
		<div className="mt-20 fixed inset-0 flex items-center justify-center bg-black bg-opacity-50">
			<div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
				<div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark flex justify-between items-center">
					<h3 className="font-medium text-black dark:text-white">
						Editar País
					</h3>
					<button onClick={handleCloseUpdateModal} className="text-black dark:text-white">
						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
							<path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
						</svg>
					</button>
				</div>
				<form onSubmit={formik.handleSubmit}>
					<div className="p-6.5 scroll-smooth">
						<div className="mb-4.5 flex flex-col gap-6 xl:flex-row">
							<div className="w-full xl:w-1/2">
								<label className="mb-2.5 block text-black dark:text-white">
									Nombre
								</label>
								<input
									type="text"
									name="Name"
									value={formik.values.Name}
									onChange={formik.handleChange}
									onBlur={formik.handleBlur}
									className="w-full rounded border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
								/>
								{formik.touched.Name && formik.errors.Name ? (
									<p className="text-red-500 text-sm mt-1">{formik.errors.Name}</p>
								) : null}
							</div>
							<div className="w-full xl:w-1/2">
								<label className="mb-2.5 block text-black dark:text-white">
									Código Región
								</label>
								<input
									type="text"
									name="CodReg"
									value={formik.values.CodReg}
									onChange={formik.handleChange}
									onBlur={formik.handleBlur}
									className="w-full rounded border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary dark:border-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
								/>
								{formik.touched.CodReg && formik.errors.CodReg ? (
									<p className="text-red-500 text-sm mt-1">{formik.errors.CodReg}</p>
								) : null}
							</div>
						</div>
						<div className="flex justify-end border-t border-stroke p-6.5 dark:border-strokedark">
							<button
								type="submit"
								className="rounded bg-primary py-2.5 px-6 text-base font-medium text-white shadow-button transition hover:opacity-80"
								disabled={formik.isSubmitting || !formik.isValid}
							>
								Guardar
							</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	);
};

export default UpdateCountryModal;