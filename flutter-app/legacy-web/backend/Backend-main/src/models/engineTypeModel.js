import getConnection from '../database/db.js'; // Import the function to establish a connection to the database
import sql from 'mssql'; // Import the mssql library for SQL Server interactions

// Get all engine types
const getEngineTypesQuery = async () => {
	try {
		const storedProcedure = 'Get_Engine_Types';// stored procedure
		const pool = await getConnection();
		const result = await pool.request().execute(storedProcedure);// Execute the stored procedure
		return result.recordset; // Return the recordset (results)
	} catch (err) {
		console.error('SQL error in getEngineTypesQuery:', err);
		throw new Error('Error fetching engines'); 
	}
};

// Create a new engine type
const createEngineTypeQuery = async (engine_type) => {
	try {
		const pool = await getConnection();
		// stored procedure
		const storedProcedure = 'Insert_Engine_Type';
		// Execute stored procedure
		const result = await pool.request()
			.input('Description', sql.NVarChar, engine_type.description)
			.execute(storedProcedure);
		// Return the number of affected rows from the insertion
		return result.rowsAffected[0];
	} catch (err) {
		console.error('SQL error in createEngineTypeQuery:', err);
		// Handle specific errors for unique constraint violations
		if (err.number === 2627) {
			if (err.message.includes('UQ_Engine_Type_Description')) {
				throw new Error('description duplicated'); // Error if the description already exists
			}
		}
		throw new Error('Error creating engine_type');
	}
};

// Update an existing engine type
const updateEngineTypeQuery = async (id, engine_type) => {
	try {
		const pool = await getConnection();
		// stored procedure 
		const storedProcedure = 'Update_Engine_Type';
		// Execute stored procedure
		const result = await pool.request()
			.input('ID_Type', sql.Int, id) 
			.input('Description', sql.NVarChar, engine_type.description) 
			.execute(storedProcedure);
		// Return the number of affected rows from the update
		return result.rowsAffected[0];
	} catch (err) {
		console.error('SQL error in updateEngineTypeQuery:', err);
		// Handle specific errors for unique constraint violations
		if (err.number === 2627) {
			if (err.message.includes('UQ_Engine_Type_Description')) {
				throw new Error('description duplicated');
			}
		}
		throw new Error('Error updating engine_type');
	}
};

// Delete an engine type by ID
const deleteEngineTypeQuery = async (id) => {
	try {
		const pool = await getConnection();
		// stored procedure
		const storedProcedure = 'Delete_Engine_Type';
		// Execute stored procedure
		const result = await pool.request()
			.input('ID_Type', sql.Int, id) 
			.execute(storedProcedure);
		console.log(result);
		// Return the number of affected rows from the deletion
		return result.rowsAffected;
	} catch (err) {
		console.error('SQL error in deleteEngineTypeQuery:', err);
		throw new Error('Error deleting engine_type');
	}
};

// Export the functions to be used in other modules
export {
	getEngineTypesQuery,
	createEngineTypeQuery,
	updateEngineTypeQuery,
	deleteEngineTypeQuery
};
