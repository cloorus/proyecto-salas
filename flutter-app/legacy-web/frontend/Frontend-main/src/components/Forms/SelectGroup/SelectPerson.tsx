import React, { useEffect, useMemo, useState } from "react";
import { getFetch } from "../../../utils/apiMethods";	 
import { Person } from "../../../interfaces/Interfaces"; // Person interface
import { getEndpoint } from "../../../utils/utils";		 // Function to get the endpoint

// The properties that the `SelectPerson` component accepts are defined
interface SelectGroupPersonProps {
	currentPerson?: number;			   // Person currently selectected
	setPersonId: (id: number) => void; // Function to update the selected person
}

// Functional component `SelectPerson`
const SelectPerson: React.FC<SelectGroupPersonProps> = ({ currentPerson, setPersonId }) => {
	const [selectedOption, setSelectedOption] = useState<number | ''>('');	  // State to control the selected country
	const [isOptionSelected, setIsOptionSelected] = useState<boolean>(false); // State to indicate whether an option has been selected
	const [data, setData] = useState<Person[]>([]);							  // State to store country data
	const [refreshData, setRefreshData] = useState<boolean>(true);			  // // State to control whether data should be refreshed

	const endpoint = getEndpoint('persons'); // Gets the corresponding endpoint

    // useEffect that gets the data
	useEffect(() => {
		const fetchData = async () => {
			try {
				const result = await getFetch(`${endpoint}`); // The request is made to the API and the results are stored
				setData(result as Person[]);
				setRefreshData(false);
			} catch (err) {
				console.error("Error fetching data:", err);
			}
		};
		if (refreshData) {
			fetchData();
		}
	}, [refreshData]); // Executed when `refreshData` changes

	// Generates select options based on `data`
	const options = useMemo(() => {
		if (refreshData) { // While data is loading, "Loading" is displayed
			return (
				<option key="loading" disabled>
					Cargando datos...
				</option>
			);
		}

		// The select options are created
		return data.map((item, index) => (
			<option key={item.ID_Person} value={item.ID_Person} title={item.Name}>
				{/* If the name is too long, it is truncated */}
				{index + 1}. {item.Name.length > 20 ? `${item.Name.substring(0, 20)}...` : item.Name}
			</option>
		));
	}, [data, refreshData]);

  	// useEffect that is executed when the current person or the data obtained changes
	useEffect(() => {
		if (currentPerson) {
			const person = data.find((item) => item.ID_Person === currentPerson); // Check that the current country exists
			if (person) { // If the current country exists, update the state of the selected option
				setSelectedOption(person.ID_Person ? person.ID_Person : '');
				setIsOptionSelected(true);
			} else {	  // If the country does not exist in the list, clear the selection
				setSelectedOption('');
				setIsOptionSelected(false);
			}
		} else { // If there is no current country, reset the selection
			setSelectedOption('');
			setIsOptionSelected(false);
		}
	}, [currentPerson, data]); // Executed when `currentPerson` or `data` changes

	// Executed when changing the person in the select
	const handleChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
		const value = e.target.value;	  // Gets the selected value
		const selectedId = Number(value); // Convert the value to a number
		setSelectedOption(selectedId);    // Updates the status with the selected option
		setIsOptionSelected(!!value);     // Check if an option has been selected
		setPersonId(selectedId);		  // Call the function to update the selected person
	};

	return (
		<div> 
			<label className="mb-1 block text-black dark:text-white">
				Persona
			</label>
			<div className="relative z-20 bg-white dark:bg-form-input">
				<span className="absolute top-1/2 left-4 z-30 -translate-y-1/2">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						fill="none" viewBox="0 0 24 24"
						strokeWidth={1.5}
						stroke="currentColor"
						className="size-6"
					>
						<path
							strokeLinecap="round"
							strokeLinejoin="round"
							d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z"
						/>
					</svg>
				</span>

        		{/* Select to choose the person */}
				<select
					value={selectedOption}
					onChange={handleChange}
					className={`relative z-20 w-full appearance-none rounded border border-stroke bg-transparent py-3 pl-12 outline-none transition focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input ${isOptionSelected ? 'text-black dark:text-white' : ''}`}
				>
					<option value="" disabled className="text-body dark:text-bodydark">
						Seleccione la persona
					</option>
					{options}
				</select>
				<span className=" absolute top-1/2 right-4 z-20 -translate-y-1/2">
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
export default SelectPerson;