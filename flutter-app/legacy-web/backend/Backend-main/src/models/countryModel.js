import getConnection from '../database/db.js'; 
import sql from 'mssql'; 

// Get all countries
const getCountriesQuery = async () => {
	try {
		const storedProcedure = 'Get_Countries';
		const pool = await getConnection();
		// Execute the stored procedure 
		const result = await pool.request().execute(storedProcedure);
		// Return the result set obtained
		return result.recordset;
	} catch (err) {
		console.error('SQL error in getCountriesQuery:', err);
		throw new Error('Error fetching countries'); 
	}
};

// Create a new country
const createCountryQuery = async (country) => {
	try {
		const pool = await getConnection();
		const storedProcedure = 'Insert_Country';
		// Execute the stored procedure
		const result = await pool.request()
			.input('Name', sql.NVarChar, country.name) 
			.input('Cod_Reg', sql.NVarChar, country.cod_reg) 
			.execute(storedProcedure);
		// Return the number of affected rows from the insertion
		return result.rowsAffected[0];
	} catch (err) {
		// Handle specific errors for unique constraint violations
		if (err.number === 2627) {
			if (err.message.includes('Name_Unique')) {
				throw new Error('name duplicated'); // Error if the name already exists
			}
			if (err.message.includes('Country_Unique')) {
				throw new Error('cod_reg duplicated'); // Error if the code already exists
			}
		}
		console.error('SQL error in createCountryQuery:', err);
		throw new Error('Error creating country');
	}
};

// Update an existing country
const updateCountryQuery = async (id, country) => {
	try {
		const pool = await getConnection();
		const storedProcedure = 'Update_Country';
		// Execute the stored procedure 
		const result = await pool.request()
			.input('ID_Country', sql.Int, id)
			.input('Name', sql.NVarChar, country.name)
			.input('Cod_Reg', sql.NVarChar, country.cod_reg) 
			.execute(storedProcedure);
		// Return the number of affected rows from the update
		return result.rowsAffected[0];
	} catch (err) {
		console.error('SQL error in updateCountryQuery:', err);
		throw new Error('Error updating country');
	}
};

// Delete a country by ID
const deleteCountryQuery = async (id) => {
	try {
		const pool = await getConnection();
		const storedProcedure = 'Delete_Country';
		// Execute stored procedure
		const result = await pool.request()
			.input('ID_Country', sql.Int, id) 
			.execute(storedProcedure);
		// Return the number of affected rows from the deletion
		return result.rowsAffected;
	} catch (err) {
		console.error('SQL error in deleteCountryQuery:', err);
		throw new Error('Error deleting country'); 
	}
};

// Export the functions to be used in other modules
export {
	getCountriesQuery,
	createCountryQuery,
	updateCountryQuery,
	deleteCountryQuery
};
