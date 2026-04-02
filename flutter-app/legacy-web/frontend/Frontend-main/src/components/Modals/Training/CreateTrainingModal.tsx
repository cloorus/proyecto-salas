import React, { useState } from "react";
import { postFetch } from "../../../utils/apiMethods";
import { Training } from "../../../interfaces/Interfaces";
import SelectGroupPerson from "../../Forms/SelectGroup/SelectPerson";
import DatePickerOne from "../../Forms/DatePicker/DatePickerOne";
import { useFormik } from "formik";
import * as Yup from "yup";
import { toast } from "react-toastify";

// Defining the types for the props expects
interface CreateEngineTypeProps {
	handleCloseCreateModal: () => void; // Function to close the create modal
	createTraining: Training; // Training to be created 
	setRefreshData: React.Dispatch<React.SetStateAction<boolean>>; // Function to trigger a refresh of the data after creation
}

const CreateTrainingModal: React.FC<CreateEngineTypeProps> = ({
	handleCloseCreateModal,
	createTraining,
	setRefreshData
}) => {

	const [personId, setPersonId] = useState<number>();
	const [date, setDate] = useState<string>();

	// Function that handles the creation process with formik and Yup to validate
	const formik = useFormik({
		initialValues: {
			Type: createTraining.Type,
			Name: createTraining.Name,
			Description: createTraining.Description
		},
		validationSchema: Yup.object({
			Type: Yup.string().required('Obligatorio'),
			Name: Yup.string().required('Obligatorio'),
			Description: Yup.string().notRequired()
		}),
		onSubmit: async (values) => {
			try {
				const training = {
					type: values.Type,
					name: values.Name,
					description: values.Description,
					date: date,
					idPerson: personId
				};

				// Making the API call to create
				const result = await postFetch("trainings", training);

				//Handle error message
				if (result.error) {
					if (result.IdPersonNull) {
						return toast.info("Selecciona una persona", {
							autoClose: 3000,
							theme: "dark"
						});
					}
					return toast.error("Algo salió mal. Intentalo de nuevo.", {
						autoClose: 3000,
						theme: "dark"
					});
				};

				// Error message if somethig were wrong
				if (result.error) {
					return toast.error("Algo salió mal. Intentalo de nuevo.", {
						autoClose: 3000,
						theme: "dark"
					});
				} else {
					// If no error, show a success message, close the modal, and refresh the data
					toast.success("Creado exitosamente", {
						autoClose: 3000,
						theme: "dark"
					});
					setRefreshData(true);
					handleCloseCreateModal();
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
		<div className="mt-20 fixed inset-0 flex items-center justify-center bg-black bg-opacity-50">
			<div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
				<div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark flex justify-between items-center">
					<h3 className="font-medium text-black dark:text-white">
						Nuevo entrenamiento
					</h3>
					<button onClick={handleCloseCreateModal} className="text-black dark:text-white">
						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
							<path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
						</svg>
					</button>
				</div>
				<form onSubmit={formik.handleSubmit} className="px-6">
					<div className='p-4 scroll-smoth'>
						<div className="mb-4 flex flex-col gap-6 xl:flex-row">
							<div className="w-full xl:w-1/2">
								<label className="mb-2 block text-black dark:text-white">Nombre entrenamieto</label>
								<input
									type="text"
									name="Name"
									value={formik.values.Name}
									onChange={formik.handleChange}
									onBlur={formik.handleBlur}
									placeholder="Ingresa el nombre del entrenamiento"
									className="w-full rounded border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
								/>
								{formik.touched.Name && formik.errors.Name ? (
									<p className="text-red-500 text-sm mt-1">{formik.errors.Name}</p>
								) : null}
							</div>
							<div className="w-full xl:w-1/2">
								<label className="mb-2 block text-black dark:text-white">Fecha entrenamiento</label>
								<DatePickerOne setDate={setDate} />
							</div>
						</div>
						<div className="mb-4 flex flex-col gap-6 xl:flex-row">
							<div className="w-full xl:w-1/2">
								<SelectGroupPerson setPersonId={setPersonId} />
							</div>
							<div className="w-full xl:w-1/2">
								<label className="mb-1 block text-black dark:text-white">Tipo</label>
								<input
									type="text"
									name="Type"
									value={formik.values.Type}
									onChange={formik.handleChange}
									onBlur={formik.handleBlur}
									placeholder="Ingresa el tipo"
									className="w-full rounded border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
								/>
								{formik.touched.Type && formik.errors.Type ? (
									<p className="text-red-500 text-sm mt-1">{formik.errors.Type}</p>
								) : null}
							</div>
						</div>
						<div className='mb-4'>
							<label className="mb-2 block text-black dark:text-white">Descripción</label>
							<input
								type="text"
								name="Description"
								value={formik.values.Description}
								onChange={formik.handleChange}
								onBlur={formik.handleBlur}
								placeholder="Ingresa la descripcion"
								className="w-full rounded border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
							/>
							{formik.touched.Description && formik.errors.Description ? (
								<p className="text-red-500 text-sm mt-1">{formik.errors.Description}</p>
							) : null}
						</div>
						<div className="flex justify-end border-t border-stroke py-2 px-1 dark:border-strokedark">
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

export default CreateTrainingModal;