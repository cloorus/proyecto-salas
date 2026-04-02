import { useEffect, useMemo, useState } from 'react';
import { getFetch } from '../../utils/apiMethods';
import { UserPerson } from '../../interfaces/Interfaces';
import Breadcrumb from '../Breadcrumbs/Breadcrumb';
import { dateFormatted, getEndpoint, paginateData } from '../../utils/utils';

interface TableUserPersonProps {
	searchedData: string | null;
}

const TableUserPerson: React.FC<TableUserPersonProps> = ({ searchedData }) => {
	// State variables for managing  data, UI state, pagination, and modal visibility.
	const [data, setData] = useState<UserPerson[]>([]);
	const [refreshData, setRefreshData] = useState<boolean>(true);

	//Current page of pagination
	const [currentPage, setCurrentPage] = useState<number>(1);

	// Define the endpoint for fetching user person data
	const endpoint = getEndpoint('users-persons');

	// Handle pagination of data
	const pagination = paginateData(data, currentPage, setCurrentPage);

	// Extract the paginated data for the current page
	const paginatedData = pagination.paginatedData;

	useEffect(() => {
		// Function to fetch user person data from the API
		const fetchData = async () => {
			try {
				const result = await getFetch(`${endpoint}`);
				setData(result as UserPerson[]);
				setRefreshData(false);
			} catch (err) {
				console.error("Error fetching data:", err);
			}
		};
		if (refreshData) fetchData();
	}, [refreshData, endpoint]);

	// Memoized function to filter the paginated data based on the searched term
	const filteredData = useMemo(() => {
		if (!searchedData) return paginatedData;

		// Convert the search term to lowercase for case-insensitive comparison
		const searchTerm = searchedData.toLowerCase();

		// Filter the paginated data based on the search term across multiple fields
		return paginatedData.filter(userPerson =>
			userPerson.Username.toLowerCase().includes(searchTerm) ||
			userPerson.Created_at.slice(0, 10).toLowerCase().includes(searchTerm)
		);
	}, [searchedData, paginatedData]);

	// Determine if there are matches for the search term
	const hasMatches = searchedData && filteredData.length > 0;


	return (
		<>
			<Breadcrumb pageName="Usuarios" />

			{/* Display the number of matches found if any exist */}
			{hasMatches && <p>Coincidencias encontradas: {filteredData.length}</p>}

			<div className="rounded-sm border border-stroke bg-white px-5 pt-6 pb-2.5 shadow-default dark:border-strokedark dark:bg-boxdark sm:px-7.5 xl:pb-1">
				<div className="max-w-full overflow-x-auto">
					<table className="w-full table-auto">
						<thead>
							<tr className="bg-gray-2 text-left dark:bg-meta-4">
								<th className="min-w-[150px] py-4 px-4 font-medium text-black dark:text-white">
									Nombre de usuario
								</th>
								<th className="min-w-[150px] py-4 px-4 font-medium text-black dark:text-white">
									Fecha de creación
								</th>
							</tr>
						</thead>
						<tbody>
							{refreshData ? (
								<tr>
									<td colSpan={7} className="py-5 text-center">Cargando los datos...</td>
								</tr>
							) : (
								// If there are filtered results display them, otherwise display all
								filteredData.length > 0 ? (
									filteredData.map((item, key) => (
										<tr key={key}>
											<td className="border-b border-[#eee] py-5 px-4 dark:border-strokedark">
												<p className="text-black dark:text-white">
													{item.Username}
												</p>
											</td>
											<td className="border-b border-[#eee] py-5 px-4 dark:border-strokedark">
												<p className="text-black dark:text-white">
													{dateFormatted(item.Created_at.slice(0, 10), "cr")}
												</p>
											</td>
										</tr>
									))
								) : (
									<tr>
										<td colSpan={7} className="py-5 text-center">No se encontraron coincidencias.</td>
									</tr>
								))}
						</tbody>
					</table>
				</div>

				{/* Pagination controls */}
				{(paginatedData.length >= 50 || pagination.isLastPage) && (
					<div className="flex items-center justify-center my-4">
						<button className='rounded bg-primary mt-4 py-1 px-2 text-base font-medium text-white shadow-button transition hover:opacity-80' onClick={pagination.handlePrevPage} disabled={currentPage === 1}>
							<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="size-6">
								<path strokeLinecap="round" strokeLinejoin="round" d="M10.5 19.5 3 12m0 0 7.5-7.5M3 12h18" />
							</svg>

						</button>
						<span className='ml-6 mt-4'>
							Página {currentPage} de {pagination.totalPages}
						</span>
						<button className='ml-6 rounded bg-primary mt-4 py-1 px-2 text-base font-medium text-white shadow-button transition hover:opacity-80' onClick={pagination.handleNextPage} disabled={currentPage === pagination.totalPages}>
							<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="size-6">
								<path strokeLinecap="round" strokeLinejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3" />
							</svg>
						</button>
					</div>
				)}
			</div>
		</>
	)
}

export default TableUserPerson;