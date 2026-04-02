import getConnection from "../database/db.js";
import sql from 'mssql'; 

// Get all engines
const getEnginesQuery = async () => {
	try {
		// stored procedure
		const storedProcedure = 'Get_Engines'; // stored procedure
		const pool = await getConnection();
		const result = await pool.request().execute(storedProcedure ); // Execute stored procedure
		// Return the recordset (results)
		return result.recordset;
	} catch (err) {
		console.error('SQL error in getEngineQuery:', err);
		throw new Error('Error fetching engines');
	}
};

// Create a new engine
const createEngineQuery = async (engine) => {
	try {
		const pool = await getConnection();
		// stored procedure
		const storedProcedure = 'Insert_Engine';
		// Execute stored procedure
		const result = await pool.request()
			.input('Model', sql.NVarChar, engine.model) 
			.input('ID_Type', sql.Int, engine.idType) 
			.input('Brand', sql.NVarChar, engine.brand) 
			.input('Link', sql.NVarChar, engine.link) 
			.input('PCB', sql.NVarChar, engine.pcb) 
			.execute(storedProcedure);
		// Return the number of affected rows from the insertion
		return result.rowsAffected[0];
	} catch (err) {
		// Handle specific errors for unique constraint violations
		if (err.number === 2627) {
			if (err.message.includes('Model_Unique')) {
				throw new Error('model duplicated'); 
			}
			if (err.message.includes('Unique_PCB')) {
				throw new Error('PCB duplicated'); 
			}
			throw new Error('Duplicate key error'); 
		}
		// Handle error for missing required fields
		if (err.number === 515) {
			if (err.message.includes('ID_Type')) {
				throw new Error('not engine type'); 
			}
		}
	}
};

// Update an existing engine
const updateEngineQuery = async (id, engine) => {
	try {
		const pool = await getConnection();
		// stored procedure
		const storedProcedure = 'Update_Engine';
		// Execute stored procedure
		const result = await pool.request()
			.input('ID_Engine', sql.Int, id) 
			.input('Model', sql.NVarChar, engine.model) 
			.input('ID_Type', sql.Int, engine.idType) 
			.input('Brand', sql.NVarChar, engine.brand) 
			.input('Link', sql.NVarChar, engine.link) 
			.execute(storedProcedure);
		// Return the number of affected rows from the update
		return result.rowsAffected[0];
	} catch (err) {
		// Handle error for missing required fields
		if (err.number === 515) {
			if (err.message.includes('ID_Type')) {
				throw new Error('not engine type'); // Error if the engine type is not provided
			}
		}
		throw new Error('Error updating engine'); 
	}
};

// Delete an engine by ID
const deleteEngineQuery = async (id) => {
	try {
		const pool = await getConnection();
		// stored procedure
		const storedProcedure = 'Delete_Engine';
		// Execute stored procedure
		const result = await pool.request()
			.input('ID_Engine', sql.Int, id)
			.execute(storedProcedure);
		// Return the number of affected rows from the deletion
		return result.rowsAffected;
	} catch (err) {
		console.error('SQL error in deleteEngineQuery:', err);
		throw new Error('Error deleting engine');
	}
};

// Export the functions to be used in other modules
export {
	getEnginesQuery,
	createEngineQuery,
	updateEngineQuery,
	deleteEngineQuery
};
