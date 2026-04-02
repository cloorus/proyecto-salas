import express from 'express';
import {
    getMemberships,        
    getMembershipById,      
    getMembershipByInst,    
    createMembership,       
    updateMembership,       
    deleteMembership        
} from '../controllers/membershipController.js'; // Import membership controllers

const router = express.Router(); // Initialize Express router

// Route to get all memberships (e.g., GET /memberships)
router.get("/", getMemberships);

// Route to get a specific membership by ID (e.g., GET /memberships/:id)
router.get("/:id", getMembershipById);

// Route to get a membership by ID installer (e.g., GET /memberships/:id/:id)
router.get("/:id/:id", getMembershipByInst);

// Route to create a new membership (e.g., POST /memberships)
router.post("/", createMembership);

// Route to update an existing membership by ID (e.g., PUT /memberships/:id)
router.put("/:id", updateMembership);

// Route to delete a membership by ID (e.g., DELETE /memberships/:id)
router.delete("/:id", deleteMembership);

export default router; // Export the router for use in other parts of the application
