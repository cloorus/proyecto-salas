import express from 'express';
import {
  getEngines,    
  getEngineByID,   
  createEngine,   
  updateEngine,    
  deleteEngine 
} from "../controllers/engineController.js"; // Import engine controllers

const router = express.Router(); // Initialize Express router

// Route to get all engines (e.g., GET /engines)
router.get("/", getEngines);

// Route to get a specific engine by ID (e.g., GET /engines/:id)
router.get("/:id", getEngineByID);

// Route to create a new engine (e.g., POST /engines)
router.post("/", createEngine);

// Route to update an existing engine by ID (e.g., PUT /engines/:id)
router.put("/:id", updateEngine);

// Route to delete an engine by ID (e.g., DELETE /engines/:id)
router.delete("/:id", deleteEngine);

export default router; // Export the router for use in other parts of the application
