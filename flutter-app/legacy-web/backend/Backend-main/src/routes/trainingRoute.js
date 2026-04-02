import express from 'express'; 
import {
	getTrainings,         
	getTrainingById,       
	getTrainingsByInst,      
	createTraining,        
	updateTraining,       
	deleteTraining          
} from "../controllers/trainingController.js"; // Import training controllers

const router = express.Router(); // Initialize Express router

// Route to get all training sessions (e.g., GET /trainings)
router.get("/", getTrainings);

// Route to get a specific training session by ID (e.g., GET /trainings/:id)
router.get("/:id", getTrainingById);

// Route to get trainings by ID installer (e.g., GET /trainings/:id/:id)
router.get("/:id/:id", getTrainingsByInst);

// Route to create a new training session (e.g., POST /trainings)
router.post("/", createTraining);

// Route to update an existing training session by ID (e.g., PUT /trainings/:id)
router.put("/:id", updateTraining);

// Route to delete a training session by ID (e.g., DELETE /trainings/:id)
router.delete("/:id", deleteTraining);

export default router; // Export the router for use in other parts of the application
