import getConnection from '../database/db.js';
import sql from 'mssql'; 

// Get all validations
const getValidationsQuery = async () => {
	try {
		const storedProcedure = 'Get_Validations'; // Stored procedure to get validations
		const pool = await getConnection();
		const result = await pool.request().execute(storedProcedure); // Execute stored procedure
		return result.recordset; // Return the result set containing validations
	} catch (err) {
		console.error('SQL error in getValidationsQuery:', err);
		throw new Error('Error fetching countries'); // Throw an error if fetching fails
	}
};

// Create validation
const createValidationQuery = async (validation) => {
	console.log(validation)
	try {
		const pool = await getConnection(); 
		// Stored procedure to insert a new validation
		const storedProcedure = 'Insert_Validation';
		// Execute stored procedure
		const result = await pool.request()
			.input('ID_Validated_Person', sql.Int, validation.id_validated_person) 
			.input('ID_Validator_Person', sql.Int, validation.id_validator_person)
			.execute(storedProcedure); 
		return result.rowsAffected[0]; // Return the number of rows affected
	} catch (err) {
		console.error('SQL error in createValidationQuery:', err);
		throw new Error('Error creating validation'); // Throw an error if creation fails
	}
};

// Delete validation
const deleteValidationQuery = async (id) => {
	try {
		const pool = await getConnection(); 
		// Stored procedure to delete a validation
		const storedProcedure = 'Delete_Validation';
		// Execute stored procedure
		const result = await pool.request()
			.input('ID_Validation', sql.Int, id)
			.execute(storedProcedure);
		return result.rowsAffected[0]; // Return the number of rows affected
	} catch (err) {
		console.error('SQL error in deleteValidationQuery:', err);
		throw new Error('Error deleting validation'); // Throw an error if deletion fails
	}
};

// Export query functions for use in other modules
export {
	getValidationsQuery,
	createValidationQuery,
	deleteValidationQuery
}
