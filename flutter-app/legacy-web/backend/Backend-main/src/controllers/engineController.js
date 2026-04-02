import {
	getEnginesQuery,
	createEngineQuery,
	updateEngineQuery,
	deleteEngineQuery
}
	from '../models/engineModel.js'

// Get all engines
const getEngines = async (req, res) => {
	try {
		const engines = await getEnginesQuery(); // Get engines
		res.json(engines);
	} catch (err) {
		console.error(err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Get engine by ID
const getEngineByID = async (req, res) => {
	try {
		const id = req.params.id;				 // Get ID from params
		const engines = await getEnginesQuery(); // Get engines

		// Filter engine by ID
		const engine = engines.filter(engine => engine.ID_Engine == id);
		
		// Engine not found
		if (!engine) {
			return res.status(404).json({ error: true});
		}
		res.json(engine);
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Create a new engine
const createEngine = async (req, res) => {
	try {
		const engine = req.body; // Get engine data from the request body
		if (!engine) {
			return res.status(400).json({ error: true});
		}

		const result = await createEngineQuery(engine); // Engine is created
		if (result === 0) {
			return res.status(400).json({ error: true});
		}

		res.status(201).json({ error: false });
	} catch (err) {
		if (err.message === 'model duplicated') { // Duplicated model error
			return res.status(400).json({ error: true, duplicatedModel: true });
		};
		if (err.message === 'PCB duplicated') { // Duplicated PCB error
			return res.status(400).json({ error: true, duplicatedPCB: true });
		};
		if (err.message === 'not engine type') { // Not engine_type provided error
			return res.status(400).json({ error: true, notEngineType: true });
		};
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Update a exixsting engine
const updateEngine = async (req, res) => {
	try {
		const id = req.params.id; // Get ID from params
		const engine = req.body;  // Get engine data from the request body
		if (!engine) {
			return res.status(400).json({ error: true});
		}

		const result = await updateEngineQuery(id, engine); // Engine is updated
		if (result === 0) {
			return res.status(400).json({ error: true});
		}

		res.status(200).json({ error: false });
	} catch (err) {
		console.error('Server error:', err.message || err);

		if (err.message === 'not engine type') { // Not engine_type provided error
			return res.status(400).json({ error: true, notEngineType: true });
		}
		res.status(500).json({ error: 'Server Error' });
	}
};

// Delete engine
const deleteEngine = async (req, res) => {
	try {
		const id = req.params.id;					// Get ID from params
		const result = await deleteEngineQuery(id); 
		if (result && result[result.length - 1] > 0) {
			return res.status(200).json({ error: false }); // Engine is deleted
		};

		return res.status(404).json({ error: true }); // Engine not found
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Export the functions to be used in other modules
export {
	getEngines,
	getEngineByID,
	createEngine,
	updateEngine,
	deleteEngine
}