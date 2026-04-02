import { useEffect, useMemo, useState } from "react";
import { Engine } from "../../interfaces/Interfaces"; // Engine interface
import { getFetch } from "../../utils/apiMethods";    
import CardDataStats from "./CardDataStats";          // Stats component
import { NavLink } from "react-router-dom";           // Component for creating navigation links

const CardEngineStats = () => {
    const [data, setData] = useState<Engine[]>([]);                // State to store engine data
    const [refreshData, setRefreshData] = useState<boolean>(true); // State to control whether data should be refreshed

    const totalEngines = useMemo(() => data.length, [data]); // Calculate the total number of engines

    // useEffect that gets the data
    useEffect(() => {
        const fetchData = async () => {
            try {
                const result = await getFetch('engines'); // The request is made to the API and the results are stored
                setData(result as Engine[]);
                setRefreshData(false);
            } catch (err) {
                console.error("Error fetching data:", err);
            }
        };
        if (refreshData) fetchData();
    }, [refreshData]); // Executed when `refreshData` changes

    return (
        // Render the `CardDataStats` component with the total engines
        <CardDataStats
            title="Total de motores"
            total={totalEngines}
            icon={
                <NavLink to='tables/engines'>
                    <svg className="size-6" stroke='#3C50E0' fill='#3C50E0' viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">
                        <path d="m482 181h-30v-61h-121v-30h30v-90h-210v90h30v30h-121v91h-30v-30h-30v151h30v-30h30v90h61v15c0 8.269531-6.730469 15-15 15-41.355469 0-75 33.644531-75 75v15h255c57.898438 0 105-47.101562 105-105v-15h61v-60h30v30h30v-211h-30zm-301-151h150v30h-150zm30 60h90v30h-90zm-181 182v-31h30v31zm33.570312 210c6.191407-17.460938 22.871094-30 42.429688-30 24.8125 0 45-20.1875 45-45v-15h30v15c0 41.355469-33.644531 75-75 75-9.464844 0-33.03125 0-42.429688 0zm177.328126-1.492188c18.605468-18.953124 30.101562-44.910156 30.101562-73.507812v-15h30v15c0 36.253906-25.859375 66.578125-60.101562 73.507812zm.101562-73.507812c0 36.253906-25.859375 66.578125-60.101562 73.507812 18.605468-18.953124 30.101562-44.910156 30.101562-73.507812v-15h30zm120 0c0 36.253906-25.859375 66.578125-60.101562 73.507812 18.605468-18.953124 30.101562-44.910156 30.101562-73.507812v-15h30zm61-45h-332v-212h332zm30-60v-91h30v91zm0 0" />
                        <path d="m151 302h30v30h-30zm0 0" />
                        <path d="m241 302h30v30h-30zm0 0" />
                        <path d="m331 302h30v30h-30zm0 0" />
                        <path d="m121 181h270v30h-270zm0 0" />
                    </svg>
                </NavLink>
            }
        />
    )
}

// Export the component
export default CardEngineStats;