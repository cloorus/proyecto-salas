import {
	getEngineTypesQuery,
	createEngineTypeQuery,
	updateEngineTypeQuery,
	deleteEngineTypeQuery
}
	from '../models/engineTypeModel.js'

// Get all engine types
const getEngineTypes = async (req, res) => {
	try {
		const engineTypes = await getEngineTypesQuery(); // Get engine types
		res.json(engineTypes);
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Get engine type by ID
const getEngineTypeByID = async (req, res) => {
	try {
		const id = req.params.id;						 // Get ID from params
		const engineTypes = await getEngineTypesQuery(); // Get engine types

		// Filter engine type by ID
		const engineType = engineTypes.filter(engineType => engineType.ID_Type == id);

		// Engine type not found
		if (!engineType) {
			return res.status(404).json({ error: true });
		}
		res.json(engineType);
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Create a new engine type
const createEngineType = async (req, res) => {
	try {
		const engineType = req.body; // Get engine type data from the request body
		if (!engineType) {
			return res.status(400).json({ error: true });
		}

		const result = await createEngineTypeQuery(engineType); // Engine type is updated
		if (result === 0) {
			return res.status(400).json({ error: true });
		}

		res.status(201).json({ error: false});
	} catch (err) {
		console.error(err.message)
		if (err.message === 'description duplicated') { // Duplicated description error
			res.status(400).json({ error: true, duplicatedDescription: true});
		}
	}
};

// Update a existing engine type
const updateEngineType = async (req, res) => {
	try {
		const id = req.params.id;	  // Get ID from params
		const engine_type = req.body; // Get engine type data from the request body
		if (!engine_type) {
			return res.status(400).json({ error: true });
		}

		const result = await updateEngineTypeQuery(id, engine_type); // Engine type is updated
		if (result === 0) {
			return res.status(400).json({ error: true });
		}

		res.status(200).json({error: false});
	} catch (err) {
		console.error('Server error:', err.message || err);
		if (err.message === 'description duplicated') { // Duplicated description error
			return res.status(400).json({ error: true, duplicatedDescription: true});
		}
		res.status(500).json({ error: 'Server Error' });
	}
};

// Delete engine type
const deleteEngineType = async (req, res) => {
	try {
		const id = req.params.id;						// Get ID from paramas
		const result = await deleteEngineTypeQuery(id); 
		if (result && result[result.length - 1] > 0) {
			return res.status(200).json({ error: false }); // Engine type is deleted
		};

		return res.status(404).json({ error: true }); // Engine type not found
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	};
};

// Export the functions to be used in other modules
export {
	getEngineTypes,
	getEngineTypeByID,
	createEngineType,
	updateEngineType,
	deleteEngineType
};