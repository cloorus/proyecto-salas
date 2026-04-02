import {
    getRolesPersonsQuery,
    createRolePersonQuery,
    updateRolePersonQuery,
    deleteRolePersonQuery
} from '../models/rolePersonModel.js';
import { getValidationsQuery } from '../models/validationModel.js'

// Get al role persons
const getRolesPersons = async (req, res) => {
    try {
        const rolesPersons = await getRolesPersonsQuery(); // Get role persons
        res.json(rolesPersons);
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Get role persons by ID with validation filtering
const getRolePersonById = async (req, res) => {
    try {
        const id = req.params.id;                         // Get ID from params
        const rolesPerson = await getRolesPersonsQuery(); // Get role persons
        const validations = await getValidationsQuery();  // Get validations
        
        // Filter role persons by validations that match the validated or validator person
        const rolePerson = rolesPerson.filter(rolePerson =>
            validations.some(validation =>
                (rolePerson.ID_Person === validation.ID_Validated_Person
                    || rolePerson.ID_Person === validation.ID_Validator_Person)
                && validation.ID_Validator_Person == id
            ));

        // Role persons not found
        if (!rolePerson) {
            return res.status(404).json({ error: true });
        }
        res.json(rolePerson);
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Get role persons by installer or authorized person
const getRolesByInst = async (req, res) => {
    try {
        const id = req.params.id;                          // Get ID from params
        const rolesPersons = await getRolesPersonsQuery(); // Get Role Persons
        
        // Filter role persons by installer or authorized ID_Person
        const rolePerson = rolesPersons.filter(rolePerson => rolePerson.ID_Person == id);
        
        // Role persons not found
        if (!rolePerson) {
            return res.status(404).json({ error: true });
        }
        res.json(rolePerson);
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
}

// Create a new role person
const createRolePerson = async (req, res) => {
    try {
        const rolePerson = req.body; // Get role person data from request body
        if (!rolePerson) {
            return res.status(400).json({ error: true });
        }

        const result = await createRolePersonQuery(rolePerson); // Role Person is created
        if (result === 0) {
            return res.status(400).json({ error: true });
        }

        res.status(201).json({error: false});
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Update a existing role person
const updateRolePerson = async (req, res) => {
    try {
        const id = req.params.id;    // Get ID from params
        const rolePerson = req.body; // Get role person data from request body
        
        if (!rolePerson) {
            return res.status(400).json({ error: true });
        }

        const result = await updateRolePersonQuery(id, rolePerson); // Role Person is updated
        if (result === 0) {
            return res.status(400).json({ error: true });
        }

        res.status(200).json({error: false});
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Delete Role Person
const deleteRolePerson = async (req, res) => {
    try {
        const id = req.params.id;                       // Get ID from params
        const result = await deleteRolePersonQuery(id); 

        if (result === 0) {
            return res.status(404).json({ error: true }); // Role Person not found
        }

        res.status(200).json({ error: false }) // Role Person is deleted
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Export the functions to be used in other modules
export {
    getRolePersonById,
    getRolesPersons,
    getRolesByInst,
    createRolePerson,
    updateRolePerson,
    deleteRolePerson
}