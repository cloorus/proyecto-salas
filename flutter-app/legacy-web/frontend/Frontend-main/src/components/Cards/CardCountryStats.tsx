import { useEffect, useMemo, useState } from "react";
import { Country } from "../../interfaces/Interfaces"; // Country interface
import { getFetch } from "../../utils/apiMethods";     
import CardDataStats from "./CardDataStats";           // Stats component
import { getCurrentUser } from "../../utils/utils";    // Function to get the current user
import { NavLink } from "react-router-dom";            // Component for creating navigation links

const CardCountryStats = () => {
    const [data, setData] = useState<Country[]>([]);               // State to store country data
    const [refreshData, setRefreshData] = useState<boolean>(true); // State to control wheter data should be refreshed

    const currentUser = getCurrentUser();                      // Gets the current user
    const totalCountries = useMemo(() => data.length, [data]); // Calculate the total number of countries

    // useEffect that gets the data
    useEffect(() => {
        const fetchData = async () => {
            try {
                const result = await getFetch('countries'); // The request is made to the API and the results are stored
                setData(result as Country[]);
                setRefreshData(false);
            } catch (err) {
                console.error("Error fetching data:", err);
            }
        };
        if (refreshData) fetchData();
    }, [refreshData]); // Executed when `refreshData` changes

    return (
        // Render the `CardDataStats` component with the total countries
        <CardDataStats
            title="Total de paises"
            total={totalCountries}
            icon={ // Display a link to the countries table if the user's role is 5, otherwise display an icon.
                (currentUser.ID_Role === 5 ? ( 
                    <NavLink to='tables/countries'>
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="#3C50E0" className="size-6">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M12 21a9.004 9.004 0 0 0 8.716-6.747M12 21a9.004 9.004 0 0 1-8.716-6.747M12 21c2.485 0 4.5-4.03 4.5-9S14.485 3 12 3m0 18c-2.485 0-4.5-4.03-4.5-9S9.515 3 12 3m0 0a8.997 8.997 0 0 1 7.843 4.582M12 3a8.997 8.997 0 0 0-7.843 4.582m15.686 0A11.953 11.953 0 0 1 12 10.5c-2.998 0-5.74-1.1-7.843-2.918m15.686 0A8.959 8.959 0 0 1 21 12c0 .778-.099 1.533-.284 2.253m0 0A17.919 17.919 0 0 1 12 16.5c-3.162 0-6.133-.815-8.716-2.247m0 0A9.015 9.015 0 0 1 3 12c0-1.605.42-3.113 1.157-4.418" />
                        </svg>
                    </NavLink>
                ) : (
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="#3C50E0" className="size-6">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M12 21a9.004 9.004 0 0 0 8.716-6.747M12 21a9.004 9.004 0 0 1-8.716-6.747M12 21c2.485 0 4.5-4.03 4.5-9S14.485 3 12 3m0 18c-2.485 0-4.5-4.03-4.5-9S9.515 3 12 3m0 0a8.997 8.997 0 0 1 7.843 4.582M12 3a8.997 8.997 0 0 0-7.843 4.582m15.686 0A11.953 11.953 0 0 1 12 10.5c-2.998 0-5.74-1.1-7.843-2.918m15.686 0A8.959 8.959 0 0 1 21 12c0 .778-.099 1.533-.284 2.253m0 0A17.919 17.919 0 0 1 12 16.5c-3.162 0-6.133-.815-8.716-2.247m0 0A9.015 9.015 0 0 1 3 12c0-1.605.42-3.113 1.157-4.418" />
                    </svg>
                ))
            }
        />
    )
}

// Export the component
export default CardCountryStats;