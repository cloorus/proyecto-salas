import getConnection from '../database/db.js';
import sql from 'mssql';

// Get all roles
const getRolesPersonsQuery = async () => {
    try {
        const pool = await getConnection(); 
        const storedProcedure = 'Get_Roles_Persons'; // stored procedure
        const result = await pool.request().execute(storedProcedure); // Execute stored procedure
        return result.recordset; // Return the results
    } catch (err) {
        console.error('SQL error in getRolesPersonsQuery:', err);
        throw new Error('Error fetching roles persons'); 
    }
};

// Create a new role-person association
const createRolePersonQuery = async (rolePerson) => {
    try {
        const pool = await getConnection(); 
        const storedProcedure = `Insert_Role_Person`; // stored procedure
        const result = await pool.request()
            .input('ID_Role', sql.Int, rolePerson.roleId)
            .input('ID_Person', sql.Int, rolePerson.personId)
            .execute(storedProcedure); // Execute stored procedure
        return result.rowsAffected[0]; // Return the number of rows affected
    } catch (err) {
        console.error('SQL error in createRolePersonQuery:', err);
        throw new Error('Error creating role person'); 
    }
};

// Update an existing role-person association
const updateRolePersonQuery = async (id, rolePerson) => {
    try {
        const pool = await getConnection();
        const storedProcedure = `Update_Role_Person`; // stored procedure
        const result = await pool.request()
            .input('ID_Role_Person', sql.Int, id) 
            .input('ID_Role', sql.Int, rolePerson.roleId)
            .execute(storedProcedure); // Execute stored procedure
        return result.rowsAffected[0]; // Return the number of rows affected
    } catch (err) {
        console.error('SQL error in updateRolePersonQuery:', err);
        throw new Error('Error updating role person');
    }
};

// Delete a role-person association
const deleteRolePersonQuery = async (id) => {
    try {
        const pool = await getConnection();
        const storedProcedure = `Delete_Role_Person`; // stored procedure
        const result = await pool.request()
            .input('ID_Role_Person', sql.Int, id) 
            .execute(storedProcedure ); // Execute stored procedure
        return result.rowsAffected[0]; // Return the number of rows affected
    } catch (err) {
        console.error('SQL error in deleteRolePersonQuery:', err);
        throw new Error('Error deleting role person');
    }
};

// Export query functions for use in other modules
export {
    getRolesPersonsQuery,
    createRolePersonQuery,
    updateRolePersonQuery,
    deleteRolePersonQuery
};
