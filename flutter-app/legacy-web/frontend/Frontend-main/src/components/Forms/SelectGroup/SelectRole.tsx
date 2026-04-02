import React, { useEffect, useState } from "react";
import { getFetch } from "../../../utils/apiMethods";  
import { Role } from "../../../interfaces/Interfaces"; // Role interface
import { getCurrentUser } from "../../../utils/utils"; // Function to get the current user

// The properties that the `SelectRole` component accepts are defined
interface SelectRoleProps {
	currentRole?: string;			  // Role currently selected
	setRoleId?: (id: number) => void; // Function to update the selected role
}

// Functional component `SelectRole`
const SelectRole: React.FC<SelectRoleProps> = ({ currentRole, setRoleId: setRoleId }) => {
	const [selectedOption, setSelectedOption] = useState<number | ''>('');	  // State to control the selected role
	const [isOptionSelected, setIsOptionSelected] = useState<boolean>(false); // State to indicate whether an option has been selected
	const [data, setData] = useState<Role[]>([]);							  // State to store country data

	const currentUser = getCurrentUser(); // Gets the current user

  	// useEffect that gets the data
	useEffect(() => {
		const fetchData = async () => {
			try {
				const result = await getFetch('roles'); // The request is made to the API and the results are stored
				setData(result as Role[]);
			} catch (err) {
				console.error("Error fetching data:", err);
			}
		};
		fetchData();
	}, []);

	// useEffect that is executed when the current role or the data obtained changes
	useEffect(() => {
		if (currentRole) {
			const role = data.find((item) => item.Description === currentRole); // Check that the current role exists
			if (role) { // If the current role exists, update the state of the selected option
				setSelectedOption(role.ID_Role);
				setIsOptionSelected(true);
			} else {	// If the role does not exist in the list, clear the selection
				setSelectedOption('');
				setIsOptionSelected(false);
			}
		} else { // If there is no current country, reset the selection
			setSelectedOption('');
			setIsOptionSelected(false);
		}
	}, [currentRole, data]); // Executed when `currentRole` or `data` changes

    // Executed when changing the role in the select
	const handleChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
		const value = e.target.value;		  // Gets the selected value
		const selectedId = Number(value);	  // Convert the value to a number
		setSelectedOption(selectedId);		  // Updates the status with the selected option
		setIsOptionSelected(!!value);		  // Check if an option has been selected
		if (setRoleId) setRoleId(selectedId); // If `setRoleId` exists, update the selected role
	};

	return (
		<div>
			<label className="mb-1 block text-black dark:text-white">
				Rol
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
							d="M17.982 18.725A7.488 7.488 0 0 0 12 15.75a7.488 7.488 0 0 0-5.982 2.975m11.963 0a9 9 0 1 0-11.963 0m11.963 0A8.966 8.966 0 0 1 12 21a8.966 8.966 0 0 1-5.982-2.275M15 9.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"
						/>
					</svg>
				</span>

        		{/* Select to choose the role */}
				<select
					value={selectedOption}
					onChange={handleChange}
					className={`relative z-20 w-full appearance-none rounded border border-stroke bg-transparent py-3 px-12 outline-none transition focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input ${isOptionSelected ? 'text-black dark:text-white' : ''}`}
				>
					<option value="" disabled className="text-body dark:text-bodydark">
						Seleccione el rol que quiere asignar
					</option>

					{/* Maps the filtered roles to display in the select */}
					{data.filter((item) => {
						if (currentUser.ID_Role === 4) return item.ID_Role === 6;
						if (currentUser.ID_Role === 3) return item.ID_Role >= 4;
						if (currentUser.ID_Role === 2) return item.ID_Role >= 3;
						return item.ID_Role !== 1;
					})
						.map((item) =>
							<option
								key={item.ID_Role}
								value={item.ID_Role}
								className="text-body dark:text-bodydark"
							>
								{item.Description}
							</option>
						)}
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
export default SelectRole;