import {
  getMembershipsQuery,
  createMembershipQuery,
  updateMembershipQuery,
  deleteMembershipQuery
} from '../models/memebershipModel.js';
import { getValidationsQuery } from '../models/validationModel.js'

// Get all memberships
const getMemberships = async (req, res) => {
  try {
    const memberships = await getMembershipsQuery();
    res.json(memberships);
  } catch (err) {
    console.error('Server error:', err.message || err);
    res.status(500).json({ error: 'Server Error' });
  }
};

// Get memberships by ID with validation filtering
const getMembershipById = async (req, res) => {
  try {
    const id = req.params.id;                        // Get ID from params
    const memberships = await getMembershipsQuery(); // Get memberships
    const validations = await getValidationsQuery(); // Get validations

    // Filter memberships by validations that match the validated or validator person
    const membershipById = memberships.filter(membership =>
      validations.some(validation =>
        (membership.ID_Person === validation.ID_Validated_Person
          || membership.ID_Person === validation.ID_Validator_Person)
        && validation.ID_Validator_Person == id
      ));

    // Memberships not found
    if (!membershipById) {
      return res.status(404).json({ error: true });
    }
    res.json(membershipById);
  } catch (err) {
    console.error('Server error:', err.message || err);
    res.status(500).json({ error: 'Server Error' });
  }
};

// Get memberships by installer or authorized person
const getMembershipByInst = async (req, res) => {
  try {
    const id = req.params.id;                        // Get ID from params
    const memberships = await getMembershipsQuery(); // Get Memberships
    // Filter activations by installer or authorized ID_Person
    const membership = memberships.filter(membership => membership.ID_Person == id);
    if (!membership) {
      return res.status(400).json({ error: true });
    } 
    res.json(membership);
  } catch (err) {
    console.error('Server error:', err.message || err);
    res.status(500).json({ error: 'Server Error' });
  }
}

// Create a new membership
const createMembership = async (req, res) => {
  try {
    const membership = req.body; // Get membership data from the request body
    if (!membership) {
      return res.status(400).json({ error: true });
    }
    const result = await createMembershipQuery(membership); 
    if (result === 0) {
      return res.status(400).json({ error: true });
    }

    res.status(201).json({ error: false }); // Membership is created
  } catch (err) {
    console.error('Server error:', err.message || err);
    res.status(500).json({ error: 'Server Error' });
  }
};

// Update a existing membership
const updateMembership = async (req, res) => {
  try {
    const id = req.params.id;    // Get ID from params
    const membership = req.body; // Get membership data from the request body
    if (!membership) {
      return res.status(400).json({ error: true });
    }

    const result = await updateMembershipQuery(id, membership); 
    if (result === 0) {
      return res.status(400).json({ error: 'Failed to update membership' });
    }

    res.status(200).json({ error: false }); // Membership is updated
  } catch (err) {
    console.error('Server error:', err.message || err);
    res.status(500).json({ error: 'Server Error' });
  }
};

// Delete Membership
const deleteMembership = async (req, res) => {
  try {
    const id = req.params.id;                       // Get ID from params
    const result = await deleteMembershipQuery(id); 

    if (result === 0) {
      return res.status(404).json({ error: true }); // Membership not found
    }

    res.status(200).json({ error: false }); // Membership is deleted
  } catch (err) {
    console.error('Server error:', err.message || err);
    res.status(500).json({ error: 'Server Error' });
  }
};

// Export the functions to be used in other modules
export {
  getMemberships,
  getMembershipById,
  getMembershipByInst,
  createMembership,
  updateMembership,
  deleteMembership
};


