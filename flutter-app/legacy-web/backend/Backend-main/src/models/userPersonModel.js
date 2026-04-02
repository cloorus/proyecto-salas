import getConnection from '../database/db.js';
import sql from 'mssql';
import bcrypt from 'bcryptjs';

// Retrieve all users and their associated person information
const getUsersPersonsQuery = async () => {
  try {
    const storedProcedure = 'Get_Users_Person'; // Stored procedure to get users
    const pool = await getConnection(); // Get a database connection
    const result = await pool.request().execute(storedProcedure); // Execute stored procedure
    return result.recordset; // Return the result set
  } catch (err) {
    console.error('SQL error in getUsersPersonsQuery:', err); // Log the error
    throw new Error('Error fetching persons'); // Throw an error if fetching fails
  }
};


// Authenticate a user by username and return their details and role
const authUserPersonQuery = async (authUserPerson) => {
  try {
    const pool = await getConnection(); // Get a database connection

    // Query to fetch user information based on username
    const query1 = `SELECT
                      up.ID_User,
                      up.Username,
                      up.Password,
                      up.Temp_Password,
                      up.ID_Person,
                      p.Email,
                      up.Active_Session
                    FROM User_Person up
                    INNER JOIN Person p
                    ON up.ID_Person = p.ID_Person
                    WHERE Username = @Username
                      `;
    const userResult = await pool.request()
      .input('Username', sql.NVarChar, authUserPerson.username) // Input parameter for username
      .query(query1); // Execute the query

    // Check if user exists
    if (userResult.recordset.length === 0) {
      throw new Error(`No user found with username: ${authUserPerson.username}`);
    }

    const userId = userResult.recordset[0].ID_Person; // Get user ID for role lookup
    // Query to fetch user roles based on person ID
    const query2 = 'SELECT * FROM Role_Person WHERE ID_Person = @ID_Person';
    const roleResult = await pool.request()
      .input('ID_Person', sql.Int, userId) // Input parameter for user ID
      .query(query2); // Execute the query

    return [userResult, roleResult]; // Return user and role information

  } catch (err) {
    console.error(`SQL error in authUserPersonQuery for user: ${authUserPerson.username}`, err);
    throw new Error('Error fetching user and role information'); // Throw error if fetching fails
  }
};

const userPersonSessionQuery = async (session) => {
  try {
    const pool = await getConnection();
    const query = 'UPDATE User_Person SET Active_Session = @Active_Session WHERE ID_Person = @ID_Person';
    const activeSessionResult = await pool.request()
      .input('Active_Session', sql.Int, session.value)
      .input('ID_Person', sql.Int, session.idPerson)
      .query(query);
      return activeSessionResult;
  } catch (err) {
    console.error('SQL error in userPersonSessionQuery:', err); // Log the error
  }
};

// Create a new user and associate it with a person
const createUserPersonQuery = async (userPerson) => {
  try {
    const pool = await getConnection(); // Get a database connection
    const storedProcedure = `Insert_User_Person`;
    const result = await pool.request()
      .input('Username', sql.NVarChar, userPerson.username) 
      .input('Password', sql.NVarChar, userPerson.password) 
      .input('Temp_Password', sql.NVarChar, userPerson.tempPassword) 
      .input('ID_Person', sql.Int, userPerson.idPerson)
      .execute(storedProcedure); // Execute stored procedure

    // Return the number of rows affected
    return result.rowsAffected[0]; 
  } catch (err) {
    console.error('SQL error in createUserPersonQuery:', err); // Log the error
    if (err.number === 2627) { // Check for unique constraint violation
      if (err.message.includes('Username_Unique')) {
        throw new Error('duplicated username'); // Throw error for duplicate username
      }
    }
    throw new Error('Error creating user person'); // Throw error if creation fails
  }
};

// Update user information based on ID
const updateUserPersonQuery = async (id, userPerson) => {
  console.log('updateUserPersonQuery', userPerson, id);
  try {
    const pool = await getConnection(); // Get a database connection

    // Query to fetch current user information
    const query = `SELECT
                    up.ID_User,
                    up.Username,
                    up.Password,
                    up.Temp_Password,
                    up.ID_Person,
                    p.Email
                   FROM User_Person up
                   INNER JOIN Person p
                   ON up.ID_Person = p.ID_Person
                   WHERE up.ID_Person = @ID_Person AND up.Username = @Username`;

    const query2 = `Update_User_Person
                   @ID_Person = @ID_Person, @Username = @Username, @Password = @Password, @Temp_Password = @Temp_Password`;

    const result = await pool.request()
      .input('ID_Person', sql.Int, id) // Input parameter for person ID
      .input('Username', sql.NVarChar, userPerson.username) // Input parameter for username
      .query(query); // Execute the query

    // Verify if old password matches the stored password
    const isMatch = await bcrypt.compare(userPerson.oldPassword, result.recordset[0].Password);
    if (!isMatch) {
      console.error('Old password is wrong');
      throw new Error('Old password is wrong'); // Throw error if old password is incorrect
    }
                       
    // Execute the update query with new information
    const result2 = await pool.request()
      .input('Username', sql.NVarChar, userPerson.username) // Input parameter for new username
      .input('Password', sql.NVarChar, userPerson.newPassword) // Input parameter for new password
      .input('Temp_Password', sql.NVarChar, userPerson.tempPassword) // Input parameter for temporary password
      .input('ID_Person', sql.Int, id) // Input parameter for person ID
      .query(query2); // Execute the update query

    return result2; // Return the result of the update operation
  } catch (err) {
    console.error('SQL error in updateUserPersonQuery:', err); // Log the error
    throw new Error('Error updating person'); // Throw error if update fails
  }
};

// Update temporary password for a user based on their ID
const updateTempPasswordQuery = async (id, tempPassword) => {
  console.log(id, tempPassword);
  try {
    const pool = await getConnection(); // Get a database connection
    const query = `UPDATE User_Person SET Password = @Password, Temp_Password = @Temp_Password WHERE ID_Person = @ID_Person`;
    const result = await pool.request()
      .input('ID_Person', sql.Int, id) // Input parameter for person ID
      .input('Password', sql.NVarChar, tempPassword) // Input parameter for new password
      .input('Temp_Password', sql.NVarChar, tempPassword) // Input parameter for new temporary password
      .query(query); // Execute the update query
    console.log(result);
    return result; // Return the result of the update operation
  } catch (error) {
    console.error(`SQL error in updateTempPasswordQuery`, error); // Log the error
    throw new Error('Error updating temp password'); // Throw error if update fails
  }
}

// Delete a user based on their ID
const deleteUserPersonQuery = async (id) => {
  try {
    const pool = await getConnection(); // Get a database connection
    const query = 'Delete_User_Person'; // Stored procedure to delete user
    const result = await pool.request()
      .input('ID_User', sql.Int, id) // Input parameter for user ID
      .query(query); // Execute the delete query
    return result.rowsAffected[0]; // Return the number of rows affected
  } catch (err) {
    console.error('SQL error in deletePersonQuery:', err); // Log the error
    throw new Error('Error deleting person'); // Throw error if deletion fails
  }
};

export {
  getUsersPersonsQuery,
  authUserPersonQuery,
  userPersonSessionQuery,
  createUserPersonQuery,
  updateUserPersonQuery,
  updateTempPasswordQuery,
  deleteUserPersonQuery
};
