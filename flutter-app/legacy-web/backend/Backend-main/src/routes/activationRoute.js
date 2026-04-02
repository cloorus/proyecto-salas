import express from 'express';
import {
    getActivations,
    getActivationById,    
    getActivationByIdInst,  
    createActivation,   
    updateActivation, 
    deleteActivation 
} from "../controllers/activationController.js"; // Import activation controllers

const router = express.Router(); // Initialize Express router

// Route to get all activations (e.g., GET /activations)
router.get("/", getActivations);

// Route to get a specific activation by ID (e.g., GET /activations/:id)
router.get("/:id", getActivationById);

// Route to get a specific activation by ID installer (e.g., GET /activations/:id/:id)
router.get("/:id/:id", getActivationByIdInst);

// Route to create a new activation (e.g., POST /activations)
router.post("/", createActivation);

// Route to update an existing activation by ID (e.g., PUT /activations/:id)
router.put("/:id", updateActivation);

// Route to delete an activation by ID (e.g., DELETE /activations/:id)
router.delete("/:id", deleteActivation);

export default router; // Export the router for use in other parts of the application
