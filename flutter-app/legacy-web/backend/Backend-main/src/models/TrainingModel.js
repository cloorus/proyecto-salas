import getConnection from '../database/db.js';
import sql from 'mssql';

// Get all trainings
const getTrainingsQuery = async () => {
    try {
        const pool = await getConnection(); 
        const storedProcedure = 'Get_Trainings'; // stored procedure
        const result = await pool.request().execute(storedProcedure); // Execute stored procedure
        return result.recordset; // Return the results
    } catch (err) {
        console.error('SQL error in getTrainingsQuery:', err);
        throw new Error('Error fetching trainings'); // Throw an error if the query fails
    }
};

// Create a new training
const createTrainingQuery = async (training) => {
    try {
        const pool = await getConnection(); 
        const storedProcedure = 'Insert_Training'; // stored procedure
        const result = await pool.request()
            .input('Type', sql.NVarChar, training.type)
            .input('Name', sql.NVarChar, training.name)
            .input('Description', sql.NVarChar, training.description)
            .input('Date', sql.DateTime, training.date)
            .input('ID_Person', sql.Int, training.idPerson)
            .execute(storedProcedure); // Execute stored procedure
        return result.rowsAffected[0]; // Return the number of rows affected
    } catch (err) {
        console.error('SQL error in createTrainingQuery:', err);
        if (err.number === 515 && err.message.includes('ID_Person')) {
            throw new Error('ID_Person NULL'); // Handle null ID_Person error
        }
        throw new Error('Error creating training'); // Customize the error message as needed
    }
};

// Update an existing training
const updateTrainingQuery = async (id, training) => {
    try {
        const pool = await getConnection();
        const storedProcedure = 'Update_Training'; // stored procedure
        const result = await pool.request()
            .input('ID_Training', sql.Int, id)
            .input('Type', sql.NVarChar, training.type)
            .input('Name', sql.NVarChar, training.name)
            .input('Description', sql.NVarChar, training.description)
            .input('Date', sql.DateTime, training.date)
            .execute(storedProcedure); // Execute stored procedure
        return result.rowsAffected[0]; // Return the number of rows affected
    } catch (err) {
        // Log and throw an error if the update fails
        console.error('SQL error in updateTrainingQuery:', err);
        throw new Error('Error updating training'); 
    }
};

// Delete a training
const deleteTrainingQuery = async (id) => {
    try {
        const pool = await getConnection(); 
        const storedProcedure = 'Delete_Training'; // stored procedure
        const result = await pool.request()
            .input('ID_Training', sql.Int, id) 
            .execute(storedProcedure); 
        return result.rowsAffected[0]; // Return the number of rows affected
    } catch (err) {
        console.error('SQL error in deleteTrainingQuery:', err);
        throw new Error('Error deleting training');
    }
};

// Export query functions for use in other modules
export {
    getTrainingsQuery,
    createTrainingQuery,
    updateTrainingQuery,
    deleteTrainingQuery
};
