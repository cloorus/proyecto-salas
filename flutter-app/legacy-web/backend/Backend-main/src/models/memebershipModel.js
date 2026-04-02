import getConnection from '../database/db.js'; // Import the function to establish a connection to the database
import sql from 'mssql'; // Import the mssql library for SQL Server interactions

// Get all memberships
const getMembershipsQuery = async () => {
  try {
    // stored procedure 
    const storedProcedure = 'Get_Memberships';
    const pool = await getConnection();
    // Execute the query and get the result
    const result = await pool.request().execute(storedProcedure);
    // Return the recordset (results) from the query
    return result.recordset;
  } catch (err) {
    console.error('SQL error in getMembershipsQuery:', err);
    throw new Error('Error fetching memberships');
  }
};

// Create a new membership
const createMembershipQuery = async (membership) => {
  try {
    const pool = await getConnection();
    //stored procedure
    const storedProcedure = 'Insert_Membership';
    // Execute the query with the necessary input parameters
    const result = await pool.request()
      .input('ID_Person', sql.Int, membership.idPerson)
      .input('Date_Payment', sql.DateTime, membership.datePayment)
      .input('Date_Expiration', sql.DateTime, membership.dateExpiration)
      .input('Type', sql.Int, membership.type) 
      .execute(storedProcedure);
    // Return the number of affected rows from the insertion
    return result.rowsAffected[0];
  } catch (err) {
    console.error('SQL error in createMembershipQuery:', err);
    throw new Error('Error creating membership');
  }
};

// Update an existing membership
const updateMembershipQuery = async (id, membership) => {
  try {
    const pool = await getConnection();
    // stored procedure
    const storedProcedure = 'Update_Membership';
    // Execute stored procedure
    const result = await pool.request()
    .input('ID_Membership', sql.Int, id)
    .input('Date_Payment', sql.DateTime, membership.datePayment)
    .input('Date_Expiration', sql.DateTime, membership.dateExpiration)
    .input('Type', sql.Int, membership.type) 
      .execute(storedProcedure);
    // Return the number of affected rows from the update
    return result.rowsAffected[0];
  } catch (err) {
    console.error('SQL error in updateMembershipQuery:', err);
    throw new Error('Error updating membership');
  }
};

// Delete a membership by ID
const deleteMembershipQuery = async (id) => {
  try {
    const pool = await getConnection();
    // stored procedure
    const storedProcedure = 'Delete_Membership';
    // Execute stored procedure
    const result = await pool.request()
      .input('ID_Membership', sql.Int, id)
      .execute(storedProcedure);
    return result.rowsAffected[0];  // Return the number of affected rows 
  } catch (err) {
    console.error('SQL error in deleteMembershipQuery:', err);
    throw new Error('Error deleting membership');
  }
};

// Export the functions to be used in other modules
export {
    getMembershipsQuery,
    createMembershipQuery,
    updateMembershipQuery,
    deleteMembershipQuery
};
