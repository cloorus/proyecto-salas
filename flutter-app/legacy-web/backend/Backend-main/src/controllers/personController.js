import {
  getPersonsQuery,
  createPersonQuery,
  updatePersonQuery,
  deletePersonQuery
} from '../models/personModel.js';
import { getValidationsQuery } from '../models/validationModel.js'

// Get all persons
const getPersons = async (req, res) => {
  try {
    const persons = await getPersonsQuery(); // Get persons
    res.json(persons);
  } catch (err) {
    console.error('Server error:', err.message || err);
    res.status(500).json({ error: 'Server Error' });
  }
};

// Get persons by ID installer or authorized person
const getPersonInst = async (req, res) => {
  try {
    const id = req.params.id;                // Get ID from params
    const persons = await getPersonsQuery(); // Get persons
    
    // Filter persons by installer or authorized ID_Person
    const person = persons.filter(person => person.ID_Person == id);
    
    // Persons not found
    if (!person) {
      return res.status(404).json({ error: true });
    }
    res.json(person);
  } catch (err) {
    console.error('Server error:', err.message || err);
    res.status(500).json({ error: 'Server Error' });
  }
};

// Get persons by admin with validation filtering
const getPersonsByAdmin = async (req, res) => {
  try {
    const id = req.params.id;                        // Get ID from params
    const persons = await getPersonsQuery();         // Get persons
    const validations = await getValidationsQuery(); // Get validations

    // Filter persons by validations that match the validated or validator person
    const personsByAdmin = persons.filter(person =>
      validations.some(validation =>
        (person.ID_Person === validation.ID_Validated_Person
          || person.ID_Person === validation.ID_Validator_Person)
          && validation.ID_Validator_Person == id
      ));

    // Persons not found
    if (!personsByAdmin) {
      return res.status(404).json({ error: true });
    }
    res.json(personsByAdmin);
  } catch (err) {
    console.error('Server error:', err.message || err);
    res.status(500).json({ error: 'Server Error' });
  }
};

// Create a new person
const createPerson = async (req, res) => {
  try {
    const person = req.body; // Get person data from the request body
    if (!person || !person.identify || !person.name || !person.email || !person.tel || !person.address || !person.idCountry) {
      return res.status(400).json({ error: true });
    }
    if (isNaN(person.tel)) {
      return res.status(400).json({ error: true, telNan: true });
    }
    const result = await createPersonQuery(person); // Person is created
    if (result.error) {
      return res.status(400).json({ error: true });
    }

    res.status(201).json({ error: false, idPerson: result[1].recordset[0].id, email: result[1].recordset[0].Email });

  } catch (err) {
    if (err.message === 'email duplicated') { // Duplicated email error
      return res.status(400).json({ error: true, duplicatedEmail: true });
    }

    if (err.message === 'identify duplicated') { // Duplicated identify error
      return res.status(400).json({ error: true, duplicatedIdentify: true });
    }

    if (err.message === 'tel duplicated') { // Duplicated tel error
      return res.status(400).json({ error: true, duplicatedTel: true });
    }

    console.error('Server error:', err.message || err);
    res.status(500).json({ error: 'Server Error' });
  }
};

// Update a existing person
const updatePerson = async (req, res) => {
  try {
    const id = req.params.id; // Get ID from params
    const person = req.body;  // Get person data from the request body
    if (!person) {
      return res.status(400).json({ error: true });
    }

    const result = await updatePersonQuery(id, person); // Person is updated

    if (result === 0) {
      return res.status(400).json({ error: true });
    }
    res.status(200).json({ error: false, updated: person });
  } catch (err) {
    console.error('Server error:', err.message || err);

    if (err.message === 'email duplicated') { // Duplicated email error
      return res.status(400).json({ error: true, duplicatedEmail: true });
    };

    if (err.message === 'identify duplicated') { // Duplicated identify error
      return res.status(400).json({ error: true, duplicatedIdentify: true });
    };

    if (err.message === 'tel duplicated') { // Duplicated tel error
      return res.status(400).json({ error: true, duplicatedTel: true });
    };

    res.status(500).json({ error: 'Server Error' });
  };
};

// Delete Person
const deletePerson = async (req, res) => {
  try {
    const id = req.params.id;                   // Get ID from params
    const result = await deletePersonQuery(id); 
    if (result && result[result.length - 1] > 0) {
      return res.status(200).json({ error: false }); // Person is deleted
    };
    return res.status(404).json({ error: true }); // Person not found
  } catch (err) {
    console.error('Server error:', err.message || err);
    res.status(500).json({ error: 'Server Error' });
  }
};

// Export the functions to be used in other modules
export {
  getPersons,
  getPersonsByAdmin,
  getPersonInst,
  createPerson,
  updatePerson,
  deletePerson
};
