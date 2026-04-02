import {
	getTrainingsQuery,
	createTrainingQuery,
	updateTrainingQuery,
	deleteTrainingQuery
}
from '../models/TrainingModel.js';
import { getValidationsQuery } from '../models/validationModel.js';

// Get all trainings
const getTrainings = async (req, res) => {
	try {
		const trainings = await getTrainingsQuery(); // Get trainings
		res.json(trainings);
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Get trainings by ID with validation filtering
const getTrainingById = async (req, res) => {
	try {
		const id = req.params.id;					 	 // Get ID from params
		const trainings = await getTrainingsQuery(); 	 // Get Trainings
		const validations = await getValidationsQuery(); // Get validations
		
        // Filter activations by validations that match the validated or validator person
		const trainingById = trainings.filter(training =>
			validations.some(validation =>
				(training.ID_Person === validation.ID_Validated_Person
					|| training.ID_Person === validation.ID_Validator_Person)
				&& validation.ID_Validator_Person == id
			));
		
		// Trainings not found
		if (!trainingById) {
			return res.status(404).json({ error: true });
		}
		res.json(trainingById);
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Get trainings by installer or authorized person
const getTrainingsByInst = async (req, res) => {
	try {
		const id = req.params.id;					 // Get ID from params
		const trainings = await getTrainingsQuery(); // Get trainings
		
		// Filter trainings by installer or authorized ID_Person
		const training = trainings.filter(training => training.ID_Person == id);
		
		// Trainings not found
		if (!training) {
			return res.status(404).json({ error: true });
		}
		res.json(training);
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Create a new training
const createTraining = async (req, res) => {
	try {
		const training = req.body; // Get training data from params
		if (!training) {
			return res.status(400).json({ error: true });
		}

		const result = await createTrainingQuery(training); // Get trainings
		if (result === 0) {
			return res.status(400).json({ error: true });
		}

		res.status(201).json({ error: false });
	} catch (err) {
		console.error('Server error:', err.message || err);
		if (err.message === 'ID_Person NULL') {
			return res.status(400).json({ error: true, IdPersonNull: true });
		}
		res.status(500).json({ error: 'Server Error' });
	}
};

// Update a existing training
const updateTraining = async (req, res) => {
	try {
		const id = req.params.id;  // Get ID from params
		const training = req.body; // Get training data from the request body
		
		if (!training) {
			return res.status(400).json({ error: true });
		}

		const result = await updateTrainingQuery(id, training); // Training is updated
		if (result === 0) {
			return res.status(400).json({ error: true });
		}

		res.status(200).json({ error: false });
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Delete Training
const deleteTraining = async (req, res) => {
	try {
		const id = req.params.id;					  // Get ID from params
		const result = await deleteTrainingQuery(id); // Training is updated
		if (result === 0) {
			return res.status(404).json({ error: true });
		};
		res.status(200).json({ error: false });
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	};
};

// Export the functions to be used in other modules
export {
	getTrainings,
	getTrainingById,
	getTrainingsByInst,
	createTraining,
	updateTraining,
	deleteTraining
}