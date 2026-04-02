// Base API URL for all fetch requests
const API_URL = "http://localhost:3000";

// Function to handle GET requests to the provided path
export async function getFetch(path: string): Promise<any> {
  try {

    // Perform GET request to the given path
    const response = await fetch(`${API_URL}/${path}`);

    // Parse and return the JSON response
    return await response.json();
  } catch (error) {

    // Log error and rethrow it for handling
    console.error("Error in GET request:", error);
    throw error;
  }
}

// Function to handle POST requests with data to the provided path
export async function postFetch(path: string, data: any): Promise<any> {
  try {

    // Perform POST request with the provided data and necessary headers
    const response = await fetch(`${API_URL}/${path}`, {
      method: "POST",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
      body: JSON.stringify(data),
    });

    // Parse and return the JSON response
    return await response.json();
  } catch (error) {
    // Log error and rethrow it for handling
    console.error("Error in POST request:", error);
    throw error;
  }
}

// Function to handle PUT requests with data to update the provided path
export async function putFetch(path: string, data: any): Promise<any> {
  try {

    // Perform PUT request with the provided data and necessary headers
    const response = await fetch(`${API_URL}/${path}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(data),
    });

    // Parse and return the JSON response
    return await response.json();
  } catch (error) {
    // Log error and rethrow it for handling
    console.error("Error in PUT request:", error);
    throw error;
  }
}

// Function to handle DELETE requests to the provided path
export async function deleteFetch(path: string): Promise<any> {
  try {

    // Perform DELETE request with the necessary headers
    const response = await fetch(`${API_URL}/${path}`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
      },
    });

    // Parse and return the JSON response
    return await response.json();
  } catch (error) {
    // Log error and rethrow it for handling
    console.error("Error in DELETE request:", error);
    throw error;
  }
}