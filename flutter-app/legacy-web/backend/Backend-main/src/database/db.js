import sql from 'mssql';

let pool; // This variable will hold the connection pool once it’s established

export default async function getConnection() {
  // Check if the connection pool has already been created
  if (!pool) {
    // Database connection configuration using environment variables
    const config = {
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,   
      server: process.env.DB_SERVER,      
      database: process.env.DB_DATABASE,   
      options: {
        encrypt: true,                    
        trustServerCertificate: true, 
        requestTimeout: 30000
      }
    };

    try {
      // Establishing the connection pool
      pool = sql.connect(config);
      console.log('Connection with database successfully established'); // Log success message
    } catch (error) {
      console.error('Error connecting to database', error); // Log any connection errors
      throw error; // Throw error to handle it further up in the call stack
    }
  }

  // Return the existing connection pool (or the newly established one)
  return pool;
}
