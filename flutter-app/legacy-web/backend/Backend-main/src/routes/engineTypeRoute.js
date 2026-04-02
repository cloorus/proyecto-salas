import express from 'express';
import {
	getEngineTypes,        
	getEngineTypeByID,      
	createEngineType,      
	updateEngineType,       
	deleteEngineType     
} from "../controllers/engineTypeController.js"; // Import engine type controllers

const router = express.Router(); // Initialize Express router

// Route to get all engine types (e.g., GET /engine-types)
router.get("/", getEngineTypes);

// Route to get a specific engine type by ID (e.g., GET /engine-types/:id)
router.get("/:id", getEngineTypeByID);

// Route to create a new engine type (e.g., POST /engine-types)
router.post("/", createEngineType);

// Route to update an existing engine type by ID (e.g., PUT /engine-types/:id)
router.put("/:id", updateEngineType);

// Route to delete an engine type by ID (e.g., DELETE /engine-types/:id)
router.delete("/:id", deleteEngineType);

export default router; // Export the router for use in other parts of the application
