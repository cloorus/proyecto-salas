import getConnection from '../database/db.js';
import sql from 'mssql';

// Get all persons
const getPersonsQuery = async () => {
  try {
    const storedProcedure = 'Get_Persons';
    const pool = await getConnection();
    const result = await pool.request().execute(storedProcedure);  // Execute stored procedure
    return result.recordset;  // Return the result set
  } catch (err) {
    console.error('SQL error in getPersonsQuery:', err);
    throw new Error('Error fetching persons'); 
  }
};

// Create person
const createPersonQuery = async (person) => {
  // Validate input data to ensure all fields are present and valid
  if (!person || !person.identify || !person.name || !person.email || !person.tel || !person.address || isNaN(person.idCountry)) {
    throw new Error('Invalid person data');  // Throw an error for invalid data
  }
  try {
    const pool = await getConnection(); 
    const storedProcedure = 'Insert_Person'; 
    const query = `SELECT
                      ID_Person AS id, 
	                    Email
                    FROM Person 
                    ORDER BY id DESC`;  // Query to retrieve the last inserted person data
    // Execute the stored procedure with the provided person data
    const result = await pool.request()
      .input('Identify', sql.NVarChar, person.identify)
      .input('Name', sql.NVarChar, person.name)
      .input('Email', sql.NVarChar, person.email)
      .input('Tel', sql.NVarChar, person.tel)
      .input('Address', sql.NVarChar, person.address)
      .input('ID_Country', sql.Int, person.idCountry)
      .execute(storedProcedure);
    // Execute the query to get the last inserted person
    const result2 = await pool.request().query(query);

    return [result, result2];  // Return both the insert result and the last inserted person data

  } catch (err) {
    console.error('SQL error in createMembershipQuery:', err); 
    if (err.number === 2627) {  // Check for a duplicate key error
      console.log(err.message);
      // Handle specific unique constraint violations
      if (err.message.includes('Email_Unique')) {
        throw new Error('email duplicated'); 
      } else if (err.message.includes('Identify_Unique')) {
        throw new Error('identify duplicated'); 
      } else if (err.message.includes('Tel_Unique')) {
        throw new Error('tel duplicated');  
      }
      throw new Error('Duplicate key error');  
    }
  }
};

// Update person
const updatePersonQuery = async (id, person) => {
  // Validate input data to ensure all fields are present and valid
  if (isNaN(id) || !person || !person.identify || !person.name || !person.email || !person.tel || !person.address || isNaN(person.idCountry)) {
    throw new Error('Invalid input data');  // Throw an error for invalid data
  }
  try {
    const pool = await getConnection(); 
    const storedProcedure = `Update_Person`; 
    // Execute the stored procedure
    const result = await pool.request()
      .input('ID_Person', sql.Int, id)
      .input('Identify', sql.NVarChar, person.identify)
      .input('Name', sql.NVarChar, person.name)
      .input('Email', sql.NVarChar, person.email)
      .input('Tel', sql.NVarChar, person.tel)
      .input('Address', sql.NVarChar, person.address)
      .input('ID_Country', sql.Int, person.idCountry)
      .execute(storedProcedure);
    return result.rowsAffected[0];  // Return the number of affected rows
  } catch (err) {
    console.error('SQL error in updatePersonQuery:', err);  
    if (err.number === 2627) {  // Check for a duplicate key error
      console.log(err.message);
      // Handle specific unique constraint violations
      if (err.message.includes('Email_Unique')) {
        throw new Error('email duplicated'); 
      } else if (err.message.includes('Identify_Unique')) {
        throw new Error('identify duplicated'); 
      } else if (err.message.includes('Tel_Unique')) {
        throw new Error('tel duplicated');  
      }
      throw new Error('Duplicate key error');  
    }
    throw new Error('Error updating person'); 
  }
};

// Delete person
const deletePersonQuery = async (id) => {
  try {
    const pool = await getConnection(); 
    const storedProcedure = 'Delete_Person'; 
    // Execute the stored procedure
    const result = await pool.request()
      .input('ID_Person', sql.Int, id)
      .execute(storedProcedure);
    return result.rowsAffected;  // Return the number of affected rows
  } catch (err) {
    console.error('SQL error in deletePersonQuery:', err); 
    throw new Error('Error deleting person');  // Throw a general error if deletion fails
  }
};

// Export the functions to be used in other modules
export {
  getPersonsQuery,
  createPersonQuery,
  updatePersonQuery,
  deletePersonQuery
};
