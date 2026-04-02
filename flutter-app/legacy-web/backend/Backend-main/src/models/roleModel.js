import getConnection from '../database/db.js';
import sql from 'mssql';

// Get all roles
const getRolesQuery = async () => {
    try {
        const storedProcedure = 'Get_Roles'; // stored procedure
        const pool = await getConnection(); 
        const result = await pool.request().execute(storedProcedure); // Execute stored procedure
        return result.recordset; // Return the result set
    } catch (err) {
        console.error('SQL error in getRolesQuery:', err);
        throw new Error('Error fetching roles');
    }
};

export {
    getRolesQuery
};
