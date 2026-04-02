import express from 'express'; 
import {
    getPersons,            
    getPersonsByAdmin,      
    getPersonInst,        
    createPerson,          
    updatePerson,           
    deletePerson            
} from "../controllers/personController.js"; // Import person controllers

const router = express.Router(); // Initialize Express router

// Route to get all persons (e.g., GET /persons)
router.get("/", getPersons);

// Route to get persons by admin ID (e.g., GET /persons/:id)
router.get("/:id", getPersonsByAdmin);

// Route to get a person by ID installer (e.g., GET /persons/:id/:id)
router.get("/:id/:id", getPersonInst);

// Route to create a new person (e.g., POST /persons)
router.post("/", createPerson);

// Route to update an existing person by ID (e.g., PUT /persons/:id)
router.put("/:id", updatePerson);

// Route to delete a person by ID (e.g., DELETE /persons/:id)
router.delete("/:id", deletePerson);

export default router; // Export the router for use in other parts of the application
