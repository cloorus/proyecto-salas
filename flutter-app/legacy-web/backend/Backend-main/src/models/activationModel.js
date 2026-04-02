import getConnection from '../database/db.js';
import sql from 'mssql';

// Get all activations
const getActivationsQuery = async () => {
	try {
		const storedProcedure = 'Get_Activations';
		const pool = await getConnection();
		const result = await pool.request().execute(storedProcedure); // Execute the stored procedure 
		return result.recordset; // Returning the result set
	} catch (err) {
		console.error('SQL error in getActivationQuery:', err);
		throw new Error('Error fetching activations'); // Throwing error if stored procedure fails
	}
};

// Create a new activation
const createActivationQuery = async (activation) => {
	// Validate input data before proceeding
	if (!activation || !activation.idVita || !activation.idPerson || !activation.idEngine) {
		throw new Error('Invalid input data');
	}
	try {
		const storedProcedure = 'Insert_Activation';
		const pool = await getConnection();

		// Execute the stored procedure 
		const result = await pool.request()
			.input('ID_Vita', sql.Int, activation.idVita)
			.input('ID_Person', sql.Int, activation.idPerson)
			.input('ID_Engine', sql.Int, activation.idEngine)
			.execute(storedProcedure);
		return result.rowsAffected[0]; // Returning the number of affected rows
	} catch (err) {
		console.error('SQL error in createActivationQuery :', err);
		throw new Error('Error creating activation'); // Throwing error if insert fails
	}
};

// Update an existing activation
const updateActivationQuery = async (id, activation) => {
	// Validate input data before proceeding
	if (isNaN(id) || !activation || !activation.idVita || !activation.idPerson || !activation.idEngine) {
		throw new Error('Invalid input data');
	}
	try {
		const storedProcedure = 'Update_Activation';
		const pool = await getConnection();

		// Execute the stored procedure 
		const result = await pool.request()
			.input('id', sql.Int, id) 
			.input('ID_Vita', sql.Int, activation.idVita)
			.input('ID_Engine', sql.Int, activation.idEngine)
			.execute(storedProcedure);
		return result.rowsAffected[0]; // Returning the number of affected rows
	} catch (err) {
		console.error('SQL error in updateActivationQuery:', err);
		throw new Error('Error updating activation');
	}
};

// Delete an activation by ID
const deleteActivationQuery = async (id) => {
	try {
		const pool = await getConnection();
		const storedProcedure = 'Delete_Activation';

		// Execute the stored procedure 
		const result = await pool.request()
			.input('ID_Activation', sql.Int, id) 
			.execute(storedProcedure); 
		return result.rowsAffected[0]; // Returning the number of affected rows
	} catch (err) {
		console.error('SQL error in deleteActivationQuery:', err);
		throw new Error('Error deleting activation'); 
	}
};

// Export the functions to be used in other modules
export {
	getActivationsQuery,
	createActivationQuery,
	updateActivationQuery,
	deleteActivationQuery
};
