
import { useEffect, useMemo, useState } from "react";
import { Person } from "../../interfaces/Interfaces"; // Person interface
import { getFetch } from "../../utils/apiMethods";    
import CardDataStats from "./CardDataStats";		  // Stats component
import { NavLink } from "react-router-dom";			  // Component for creating navigation links
import { getEndpoint } from "../../utils/utils";	  // Function to get the endpoint

const CardPersonStats = () => {
	const [data, setData] = useState<Person[]>([]);				   // State to store person data
	const [refreshData, setRefreshData] = useState<boolean>(true); // State to control whether data should be refreshed

	const endpoint = getEndpoint('persons');				 // Gets the corresponding endpoint
	const totalPersons = useMemo(() => data.length, [data]); // Calculate the total number of persons

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
		if (refreshData) fetchData();
	}, [refreshData, endpoint]); // Executed when `refreshData` or `endpoint` changes

	return (
        // Render the `CardDataStats` component with the total persons
		<CardDataStats
			title="Total de personas"
			total={totalPersons}
			icon={
				<NavLink to="/tables/persons">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						fill="none" viewBox="0 0 24 24"
						strokeWidth={1.5}
						stroke="#3C50E0"
						className="size-6"
					>
						<path
							strokeLinecap="round"
							strokeLinejoin="round"
							d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z"
						/>
					</svg>
				</NavLink>
			}
		/>
	)
}

// Export the component
export default CardPersonStats;