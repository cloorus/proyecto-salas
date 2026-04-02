import {
    getActivationsQuery,
    createActivationQuery,
    updateActivationQuery,
    deleteActivationQuery
} from '../models/activationModel.js';

import { getValidationsQuery } from '../models/validationModel.js'

// Get all activations
const getActivations = async (req, res) => {
    try {
        const engines = await getActivationsQuery(); // Get activations
        res.json(engines);
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Get activations by ID with validation filtering
const getActivationById = async (req, res) => {
    try {
        const id = req.params.id;                        // Get ID from params
        const activations = await getActivationsQuery(); // Get activations
        const validations = await getValidationsQuery(); // Get validations

        // Filter activations by validations that match the validated or validator person
        const activationsById = activations.filter(activation =>
            validations.some(validation =>
                (activation.ID_Person === validation.ID_Validated_Person
                    || activation.ID_Person === validation.ID_Validator_Person)
                && validation.ID_Validator_Person == id
            ));
        
        // Activations not found
        if (!activationsById) {
            return res.status(404).json({ error: true })
        }
        res.json(activationsById);
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Get activations by installer or authorized person
const getActivationByIdInst = async (req, res) => {
    try {
        const id = req.params.id;                        // Get ID from params
        const activations = await getActivationsQuery(); // Get Activations

        // Filter activations by installer or authorized ID_Person
        const activation = activations.filter(activation => activation.ID_Person == id);
        
        // Activations not found
        if (!activation) {
            return res.status(404).json({ error: true });
        }
        res.json(activation);
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Create a new activation
const createActivation = async (req, res) => {
    try {
        const activation = req.body; // Get activation data from the request body
        if (!activation) {
            return res.status(400).json({ error: true });
        }

        const result = await createActivationQuery(activation); 
        if (result === 0) {
            return res.status(400).json({ error: true});
        }

        res.status(201).json({ error: false }); // Activation is created
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Update a existing activation
const updateActivation = async (req, res) => {
    try {
        const id = req.params.id;    // Get ID from params
        const activation = req.body; // Get activation data from the request body
       
        if (!activation) {
            return res.status(400).json({ error: true });
        }

        const result = await updateActivationQuery(id, activation);
        if (result === 0) {
            return res.status(400).json({ error: true });
        }

        res.status(200).json({ error: false }); // Activation is updated
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Delete Activation
const deleteActivation = async (req, res) => {
    try {
        const id = req.params.id;                       // Get ID from params
        const result = await deleteActivationQuery(id); 
        
        // Activation not found
        if (result === 0) {
            return res.status(404).json({ error: true });
        } 
        res.status(200).json({ error: false }); // Activation is deleted
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Export the functions to be used in other modules
export {
    getActivations,
    getActivationById,
    getActivationByIdInst,
    createActivation,
    updateActivation,
    deleteActivation
};

