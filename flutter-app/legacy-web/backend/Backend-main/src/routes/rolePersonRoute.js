import express from 'express'; 
import {
    getRolePersonById,     
    getRolesPersons,        
    getRolesByInst,         
    createRolePerson,      
    updateRolePerson,      
    deleteRolePerson      
} from "../controllers/rolePersonController.js"; // Import role-person controllers

const router = express.Router(); // Initialize Express router

// Route to get all role-person relationships (e.g., GET /role-persons)
router.get("/", getRolesPersons);

// Route to get a specific role-person relationship by ID (e.g., GET /role-persons/:id)
router.get("/:id", getRolePersonById);

// Route to get roles by ID installer (e.g., GET /role-persons/:id/:id)
router.get("/:id/:id", getRolesByInst);

// Route to create a new role-person relationship (e.g., POST /role-persons)
router.post("/", createRolePerson);

// Route to update an existing role-person relationship by ID (e.g., PUT /role-persons/:id)
router.put("/:id", updateRolePerson);

// Route to delete a role-person relationship by ID (e.g., DELETE /role-persons/:id)
router.delete("/:id", deleteRolePerson);

export default router; // Export the router for use in other parts of the application
