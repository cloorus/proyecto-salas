import express from 'express';
import {
    getCountries, 
    getCountryByID,
    createCountry,
    updateCountry, 
    deleteCountry
} from "../controllers/countryController.js"; // Import country controllers

const router = express.Router(); // Initialize Express router

// Route to get all countries (e.g., GET /countries)
router.get("/", getCountries);

// Route to get a specific country by ID (e.g., GET /countries/:id)
router.get("/:id", getCountryByID);

// Route to create a new country (e.g., POST /countries)
router.post("/", createCountry);

// Route to update an existing country by ID (e.g., PUT /countries/:id)
router.put("/:id", updateCountry);

// Route to delete a country by ID (e.g., DELETE /countries/:id)
router.delete("/:id", deleteCountry);

export default router; // Export the router for use in other parts of the application
