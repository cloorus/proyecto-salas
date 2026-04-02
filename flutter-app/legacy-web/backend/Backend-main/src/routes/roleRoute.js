import express from 'express'; 
import { getRoles } from '../controllers/roleController.js'; // Import the controller function to get roles

const router = express.Router(); // Initialize Express router

// Route to get all roles (e.g., GET /roles)
router.get("/", getRoles);

export default router; // Export the router for use in other parts of the application
