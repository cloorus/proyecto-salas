import express from 'express'; 
import {
    getUsersPersons,           
    getUserPersonById,         
    getUserPersonByIdInst,     
    authUserPerson,            
    userPersonSession,        
    sendCodeToResetPassword,   
    createUserPerson,          
    updateUserPerson,         
    updateTempPassword,       
    deleteUserPerson           
} from '../controllers/userPersonController.js'; // Import user-person controllers

const router = express.Router(); // Initialize Express router

// Route to get all user-person relationships (e.g., GET /user-persons)
router.get("/", getUsersPersons);

// Route to get a specific user-person relationship by user ID (e.g., GET /user-persons/:id)
router.get("/:id", getUserPersonById);

// Route to get a user-person relationship by ID installer (e.g., GET /user-persons/:id/:id)
router.get("/:id/:id", getUserPersonByIdInst);

// Route to authenticate a user-person (e.g., POST /user-persons/auth)
router.post("/auth", authUserPerson);

// Route to manage user-person sessions (e.g., POST /user-persons/user-session)
router.post("/user-session", userPersonSession);

// Route to send a code for resetting the password (e.g., POST /user-persons/send-code)
router.post("/send-code", sendCodeToResetPassword);

// Route to create a new user-person relationship (e.g., POST /user-persons)
router.post("/", createUserPerson);

// Route to update an existing user-person relationship by user ID (e.g., PUT /user-persons/:id)
router.put("/:id", updateUserPerson);

// Route to update a temporary password for a user-person (e.g., PUT /user-persons/temp-password/:id)
router.put("/temp-password/:id", updateTempPassword);

// Route to delete a user-person relationship by user ID (e.g., DELETE /user-persons/:id)
router.delete("/:id", deleteUserPerson);

export default router; // Export the router for use in other parts of the application
