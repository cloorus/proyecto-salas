import React, { useEffect, useState } from "react";
import { getFetch } from "../../../utils/apiMethods";		 
import { EngineType } from "../../../interfaces/Interfaces"; // Engine_Type interface

// The properties that the `SelectEngineType` component accepts are defined
interface SelectEngineTypeProps {
	currentType?: string;				  // Type currently selected
	setEngineTypeId: (id:number) => void; // Function to update the selected engine type
}

// Functional component `SelecyEngineType`
const SelectEngineType: React.FC<SelectEngineTypeProps> = ({ currentType, setEngineTypeId }) => {
	const [selectedOption, setSelectedOption] = useState<number | ''>('');	  // State to control the selected engine type
	const [isOptionSelected, setIsOptionSelected] = useState<boolean>(false); // State to indicate whether an option has been selected
	const [data, setData] = useState<EngineType[]>([]);						  // State to store engine type data
	const [error, setError] = useState<string | null>(null);				  // State to handle errors

	// useEffect that gets the data
	useEffect(() => {
		const fetchData = async () => {
			try {
				const result = await getFetch('engine-types'); // The request is made to the API and the results are stored
				setData(result as EngineType[]);
			} catch (err) {
				setError("Error fetching data")
				console.error("Error fetching data:", err);
			}
		};
		fetchData();
	}, []);

  // useEffect that is executed when the current engine type or the data obtained changes
	useEffect(() => {
		if (currentType) {
			const type = data.find((item) => item.Description === currentType); // Check that the current engine type exists
			if (type) { // If the current type exists, update the state of the selected option
				setSelectedOption(type.ID_Type);
				setIsOptionSelected(true);
			} else {	// If the type does not exist in the list, clear the selection
				setSelectedOption('');
				setIsOptionSelected(false);
			}
		} else { // If there is no current country, reset the selection
			setSelectedOption('');
			setIsOptionSelected(false);
		}
	}, [currentType, data]); // Executed when `currentType` or `data` changes

  // Executed when changing the engine type in the select
	const handleChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
		const value = e.target.value;	  // Gets the selected value
		const selectedId = Number(value); // Convert the value to a number
		setSelectedOption(selectedId);	  // Updates the status with the selected option
		setIsOptionSelected(!!value);	  // Check if an option has been selected
		setEngineTypeId(selectedId);	  // Call the function to update the selected type
	};

	return (
		<div>
			<label className="mb-3 block text-black dark:text-white">
				Tipo de Motor
			</label>
			<div className="relative z-20 bg-white dark:bg-form-input">
				<span className="absolute top-1/2 left-4 z-30 -translate-y-1/2">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						fill="none" viewBox="0 0 24 24"
						strokeWidth={1.5} stroke="currentColor"
						className="size-6"
					>
						<path
							strokeLinecap="round"
							strokeLinejoin="round"
							d="M4.5 12a7.5 7.5 0 0 0 15 0m-15 0a7.5 7.5 0 1 1 15 0m-15 0H3m16.5 0H21m-1.5 0H12m-8.457 3.077 1.41-.513m14.095-5.13 1.41-.513M5.106 17.785l1.15-.964m11.49-9.642 1.149-.964M7.501 19.795l.75-1.3m7.5-12.99.75-1.3m-6.063 16.658.26-1.477m2.605-14.772.26-1.477m0 17.726-.26-1.477M10.698 4.614l-.26-1.477M16.5 19.794l-.75-1.299M7.5 4.205 12 12m6.894 5.785-1.149-.964M6.256 7.178l-1.15-.964m15.352 8.864-1.41-.513M4.954 9.435l-1.41-.514M12.002 12l-3.75 6.495"
						/>
					</svg>
				</span>

        		{/* Select to choose the engine type */}
				<select
					value={selectedOption}
					onChange={handleChange}
					className={`relative z-20 w-full appearance-none rounded border border-stroke bg-transparent py-3 px-12 outline-none transition focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input ${isOptionSelected ? 'text-black dark:text-white' : ''}`}
				>
					<option value="" disabled className="text-body dark:text-bodydark">
						Seleccione el tipo de motor
					</option>

          			{/* Mapping the list of engine types to create the select options */}
					{data.map((item) => (
						<option
							key={item.ID_Type}
							value={item.ID_Type}
							className="text-body dark:text-bodydark"
						>
							{item.Description}
						</option>
					))}
				</select>
				<span className="absolute top-1/2 right-4 z-10 -translate-y-1/2">
					<svg
						width="24"
						height="24"
						viewBox="0 0 24 24"
						fill="none"
						xmlns="http://www.w3.org/2000/svg"
					>
						<g opacity="0.8">
							<path
								fillRule="evenodd"
								clipRule="evenodd"
								d="M5.29289 8.29289C5.68342 7.90237 6.31658 7.90237 6.70711 8.29289L12 13.5858L17.2929 8.29289C17.6834 7.90237 18.3166 7.90237 18.7071 8.29289C19.0976 8.68342 19.0976 9.31658 18.7071 9.70711L12.7071 15.7071C12.3166 16.0976 11.6834 16.0976 11.2929 15.7071L5.29289 9.70711C4.90237 9.31658 4.90237 8.68342 5.29289 8.29289Z"
								fill="#637381"
							/>
						</g>
					</svg>
				</span>
			</div>
		</div>
	);
};

// Export the component
export default SelectEngineType;