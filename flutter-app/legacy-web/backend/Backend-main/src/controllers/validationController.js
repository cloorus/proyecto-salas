import {
	getValidationsQuery,
	createValidationQuery,
	deleteValidationQuery
}
	from '../models/validationModel.js'

// Get all validations
const getValidations = async (req, res) => {
	try {
		const validations = await getValidationsQuery(); // Get validations
		res.json(validations);
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Get validations by ID with validations filtering
const getValidationById = async (req, res) => {
	try {
		const id = req.params.id;						 // Get ID from params
		const validations = await getValidationsQuery(); // Get validations

		// Filter validations by validations that match the validated or validator person
		const validation = validations.filter(validation => validation.ID_Validator_Person == id);

		// Validations not found
		if (!validation) {
			return res.status(404).json({ error: true });
		}
		res.json(validation);
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Get validations by installer or authorized person
const getValidationByIdInst = async (req, res) => {
	try {
		const id = req.params.id;						 // Get ID from params
		const validations = await getValidationsQuery(); // Get Validations

		// Filter validations by installer or authorized ID_Person
		const validation = validations.filter(validation => validation.ID_Validated_Person == id);

		// Validations not found
		if (!validation) {
			return res.status(404).json({ error: true });
		}
		res.json(validation);
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Create a new validation
const createValidation = async (req, res) => {
	try {
		const validation = req.body; // Get validation data from the request body
		if (!validation) {
			return res.status(400).json({ error: true });
		}

		const result = await createValidationQuery(validation); // Validation is created
		if (result === 0) {
			return res.status(400).json({ error: true });
		}

		res.status(201).json({ error: false });
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Delete validation
const deleteValidation = async (req, res) => {
	try {
		const id = req.params.id;						// Get ID from params
		const result = await deleteValidationQuery(id); 

		// Validation not found
		if (result === 0) {
			return res.status(404).json({ error: true });
		}
		res.status(200).json({ error: false }); // Validation is deleted
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Export the functions to be used in other modules
export {
	getValidations,
	getValidationById,
	getValidationByIdInst,
	createValidation,
	deleteValidation
}