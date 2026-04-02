import { useEffect, useMemo, useState } from "react";
import { EngineType } from "../../interfaces/Interfaces"; // Engine_Type interface
import { getFetch } from "../../utils/apiMethods";        
import CardDataStats from "./CardDataStats";              // Stats component
import { NavLink } from "react-router-dom";               // Component for creating navigation links

const CardEngineTypeStats = () => {
    const [data, setData] = useState<EngineType[]>([]);            // State to store engine type
    const [refreshData, setRefreshData] = useState<boolean>(true); // State to control whether data should be refreshed

    const totalEnginesTypes = useMemo(() => data.length, [data]); // Calculate the total number of engines

    // useEffect that gets the data
    useEffect(() => {
        const fetchData = async () => {
            try {
                const result = await getFetch('engine-types'); // The request is made to the API and the results are stored
                setData(result as EngineType[]);
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
            title="Total de tipos de motor"
            total={totalEnginesTypes}
            icon={
                <NavLink to='tables/engine-types'>
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="#3C50E0" className="size-6">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M4.5 12a7.5 7.5 0 0 0 15 0m-15 0a7.5 7.5 0 1 1 15 0m-15 0H3m16.5 0H21m-1.5 0H12m-8.457 3.077 1.41-.513m14.095-5.13 1.41-.513M5.106 17.785l1.15-.964m11.49-9.642 1.149-.964M7.501 19.795l.75-1.3m7.5-12.99.75-1.3m-6.063 16.658.26-1.477m2.605-14.772.26-1.477m0 17.726-.26-1.477M10.698 4.614l-.26-1.477M16.5 19.794l-.75-1.299M7.5 4.205 12 12m6.894 5.785-1.149-.964M6.256 7.178l-1.15-.964m15.352 8.864-1.41-.513M4.954 9.435l-1.41-.514M12.002 12l-3.75 6.495" />
                    </svg>
                </NavLink>
            }
        />
    )
}

// Export the component
export default CardEngineTypeStats;