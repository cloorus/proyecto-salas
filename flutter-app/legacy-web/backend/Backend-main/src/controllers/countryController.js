import {
	getCountriesQuery,
	createCountryQuery,
	updateCountryQuery,
	deleteCountryQuery
}
	from '../models/countryModel.js'

// Get all countries
const getCountries = async (req, res) => {
	try {
		const countries = await getCountriesQuery(); // Get countries
		res.json(countries);
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Get country by ID
const getCountryByID = async (req, res) => {
	try {
		const id = req.params.id;					 // Get ID from params
		const countries = await getCountriesQuery(); // Get countries

		// Filter country by ID
		const country = countries.filter(country => country.ID_Country == id);

		// Country not found
		if (!country) {
			return res.status(404).json({ error: true});
		}
		res.json(country);
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Create a new country
const createCountry = async (req, res) => {
	try {
		const country = req.body; // Get country data from the request body
		if (!country) {
			return res.status(400).json({ error: true});
		}

		const result = await createCountryQuery(country); // Country is created
		if (result === 0) {
			return res.status(400).json({ error: true});
		}

		res.status(201).json({ error: false });
	} catch (err) {
		if (err.message === 'name duplicated') { // Duplicated name error
			return res.status(400).json({ error: true, duplicatedName: true });
		}
		if (err.message === 'cod_reg duplicated') { // Duplicated cod_reg error
			return res.status(400).json({ error: true, duplicatedCodReg: true });
		}
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Update a existing country
const updateCountry = async (req, res) => {
	try {
		const id = req.params.id; // Get ID from params
		const country = req.body; // Get country data from the request body
		if (!country) {
			return res.status(400).json({ error: true});
		}

		const result = await updateCountryQuery(id, country); // Country is updated
		if (result === 0) {
			return res.status(400).json({ error: true});
		}

		res.status(200).json({ error: false });
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	}
};

// Delete country
const deleteCountry = async (req, res) => {
	try {
		const id = req.params.id;					 // Get ID from params
		const result = await deleteCountryQuery(id); 
		if (result && result[result.length - 1] > 0) {
			return res.status(200).json({ error: false }); // Country is deleted
		};
		return res.status(404).json({ error: true }); // Country not found
	} catch (err) {
		console.error('Server error:', err.message || err);
		res.status(500).json({ error: 'Server Error' });
	};
}

// Export the functions to be used in other modules
export {
	getCountries,
	getCountryByID,
	createCountry,
	updateCountry,
	deleteCountry
}