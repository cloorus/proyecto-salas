import React, { useState } from "react";
import { postFetch } from "../../../utils/apiMethods";
import { Engine } from "../../../interfaces/Interfaces";
import SelectEngineType from "../../Forms/SelectGroup/SelectEngineType";
import { useFormik } from "formik";
import * as Yup from "yup";
import { toast } from "react-toastify";

// Defining the types for the props expects
interface CreateEngineProps {
	handleCloseCreateModal: () => void; // Function to close the create modal
	createEngine: Engine; // Engine to be created 
	setRefreshData: React.Dispatch<React.SetStateAction<boolean>>; // Function to trigger a refresh of the data after creation
}

const CreateEngineModal: React.FC<CreateEngineProps> = ({
	handleCloseCreateModal,
	createEngine,
	setRefreshData
}) => {
	const [engineTypeId, setEngineTypeId] = useState<number>();
	
	// Function that handles the creation process with formik and Yup to validate
	const formik = useFormik({
		initialValues: {
			Model: createEngine.Model,
			Brand: createEngine.Brand,
			Link: createEngine.Link,
			PCB: createEngine.PCB
		},
		validationSchema: Yup.object({
			Model: Yup.string()
				.max(200, 'El nombre del modelo es muy largo')
				.required('Obligatorio'),
			Brand: Yup.string().required('Obligatorio'),
			Link: Yup.string(),
			PCB: Yup.string()
				.max(100, 'El ID de la PCB es muy largo')
				.required('Obligatorio')
		}),
		onSubmit: async (values) => {
			try {
				const engine = {
					model: values.Model,
					idType: engineTypeId,
					brand: values.Brand,
					link: values.Link,
					pcb: values.PCB
				};
				
				//Handle error if there is not engine type ID
				if (!engineTypeId) {
					return toast.error("Ingresa el tipo de motor", {
						autoClose: 3000,
						theme: "dark"
					})
				};

				// Making the API call to create
				const result = await postFetch("engines", engine);

				//Handle error messages
				if (result.duplicatedModel) {
					toast.error("Modelo duplicado", {
						autoClose: 3000,
						theme: "dark"
					})
				};
				
				if (result.duplicatedPCB) {
					toast.error("El ID del PCB ya existe", {
						autoClose: 3000,
						theme: "dark"
					})
				};

				if (result.notEngineType) {
					toast.error("Tipo de motor no seleccionado", {
						autoClose: 3000,
						theme: "dark"
					})
				};

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
					<h3 className="font-medium text-black dark:text-white">Nuevo Motor</h3>
					<button onClick={handleCloseCreateModal} className="text-black dark:text-white">
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
									Modelo
								</label>
								<input
									type='text'
									name="Model"
									value={formik.values.Model}
									onChange={formik.handleChange}
									onBlur={formik.handleBlur}
									placeholder='Ingrese el modelo'
									className='w-full rounded border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary'
								/>
								{formik.touched.Model && formik.errors.Model ? (
									<p className="text-red-500 text-sm mt-1">{formik.errors.Model}</p>
								) : null}
							</div>
							<SelectEngineType setEngineTypeId={setEngineTypeId} />
						</div>
						<div className="mb-4.5 mt-2 flex flex-col gap-6 xl:flex-row">
							<div className="w-full xl:w-1/2">
								<label className="mb-2.5 block text-black dark:text-white">
									Marca
								</label>
								<input
									type='text'
									name="Brand"
									value={formik.values.Brand}
									onChange={formik.handleChange}
									onBlur={formik.handleBlur}
									placeholder='Ingrese la marca'
									className="w-full rounded border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
								/>
								{formik.touched.Brand && formik.errors.Brand ? (
									<p className="text-red-500 text-sm mt-1">{formik.errors.Brand}</p>
								) : null}
							</div>
							<div className="w-full xl:w-1/2">
								<label className="mb-2.5 block text-black dark:text-white">
									PCB
								</label>
								<input
									type='text'
									name="PCB"
									value={formik.values.PCB}
									onChange={formik.handleChange}
									onBlur={formik.handleBlur}
									placeholder='Ingrese el ID de la PCB'
									className="w-full rounded border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
								/>
								{formik.touched.PCB && formik.errors.PCB ? (
									<p className="text-red-500 text-sm mt-1">{formik.errors.PCB}</p>
								) : null}
							</div>
						</div>
						<div className="mb-4.5 mt-2">
							<label className="mb-2.5 block text-black dark:text-white">
								Enlace
							</label>
							<input
								type='text'
								name="Link"
								value={formik.values.Link}
								onChange={formik.handleChange}
								onBlur={formik.handleBlur}
								placeholder='Ingrese el enlace a la documentación del motor (opcional)'
								className="w-full rounded border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
							/>
							{formik.touched.Link && formik.errors.Link ? (
								<p className="text-red-500 text-sm mt-1">{formik.errors.Link}</p>
							) : null}
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
					</div>
				</form>
			</div>
		</div>
	);
};

export default CreateEngineModal;