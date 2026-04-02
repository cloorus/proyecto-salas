import { getRolesQuery } from "../models/roleModel.js";

// Get all roles
const getRoles = async (req, res) => {
    try {
        const roles = await getRolesQuery(); // Get roles
        res.json(roles);
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Export the function to be used in other modules
export {
    getRoles
}