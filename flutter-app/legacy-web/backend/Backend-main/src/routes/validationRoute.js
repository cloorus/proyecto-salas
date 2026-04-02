import express from 'express'; 
import {
    getValidations,           
    getValidationById,       
    getValidationByIdInst,    
    createValidation,         
    deleteValidation          
} from "../controllers/validationController.js"; // Import validation controllers

const router = express.Router(); // Initialize Express router

// Route to get all validations (e.g., GET /validations)
router.get("/", getValidations);

// Route to get a specific validation by ID (e.g., GET /validations/:id)
router.get("/:id", getValidationById);

// Route to get a validation by ID installer (e.g., GET /validations/:id/:id)
router.get("/:id/:id", getValidationByIdInst);

// Route to create a new validation (e.g., POST /validations)
router.post("/", createValidation);

// Route to delete a validation by ID (e.g., DELETE /validations/:id)
router.delete("/:id", deleteValidation);

export default router; // Export the router for use in other parts of the application
