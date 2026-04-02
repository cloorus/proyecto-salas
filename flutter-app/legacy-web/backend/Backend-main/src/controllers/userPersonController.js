import bcrypt from "bcryptjs";
import nodemailer from 'nodemailer';
import dotenv from 'dotenv';
dotenv.config();

import {
    getUsersPersonsQuery,
    authUserPersonQuery,
    userPersonSessionQuery,
    createUserPersonQuery,
    updateUserPersonQuery,
    updateTempPasswordQuery,
    deleteUserPersonQuery,
} from '../models/userPersonModel.js';
import { getValidationsQuery } from '../models/validationModel.js'
import { getPersonsQuery } from "../models/personModel.js";

const gmailUser = process.env.GMAIL_USER;     // Get Gmail user from environment variables
const gmailPass = process.env.GMAIL_PASSWORD; // Get Gmail password from environment variables

// Function to send an Email
const sendEmail = async (toEmail, subject, message) => {

    // Configure nodemailer transport using Gmail as a service
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: gmailUser,
            pass: gmailPass,
        }
    });

    // Configure the mail options
    const mailOptions = {
        from: gmailUser,
        to: toEmail,
        subject: subject,
        html: message
    };

    try {
        const result = await transporter.sendMail(mailOptions); // Email sent
    } catch (error) {
        console.error('Error al enviar correo:', error);
        throw new Error({ error: true })
    }
}

// Get all users
const getUsersPersons = async (req, res) => {
    try {
        const usersPersons = await getUsersPersonsQuery(); // Get users
        res.json(usersPersons);
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Get users by ID with validation filtering
const getUserPersonById = async (req, res) => {
    try {
        const id = req.params.id;                          // Get ID from params
        const usersPersons = await getUsersPersonsQuery(); // Get users
        const validations = await getValidationsQuery();   // Get validations
        
        // Filter users by validations that match the validated or validator person
        const userPersonById = usersPersons.filter(userPerson =>
            validations.some(validation =>
                (userPerson.ID_Person === validation.ID_Validated_Person
                    || userPerson.ID_Person === validation.ID_Validator_Person)
                && validation.ID_Validator_Person == id
            ));

        // Users not found
        if (!userPersonById) {
            return res.status(404).json({ error: true });
        }
        res.json(userPersonById);
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Get users by installer or authorized person
const getUserPersonByIdInst = async (req, res) => {
    try {
        const id = req.params.id;                          // Get ID from params
        const usersPersons = await getUsersPersonsQuery(); // Get users

        // Filter users by installer or authorized ID_Person
        const userPersonByIdInst = usersPersons.filter(userPerson => userPerson.ID_Person == id);
        
        // Users not found
        if (!userPersonByIdInst) {
            return res.status(404).json({ error: true });
        }
        res.json(userPersonByIdInst);
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    };
};

// Function to check if there is an open session
const userPersonSession = async (req, res) => {
    try {
        const session = req.body;                                        // Get session data from the request body
        const userPersonSession = await userPersonSessionQuery(session); // Check if there is an open session
        if (userPersonSession.rowsAffected[0] === 0) {
            return res.status(400).json({ error: true });
        };
        return res.json({ error: false });
    } catch (err) {
        res.status(500).json({ error: 'Server Error' });
    };
};

// Function to authenticate user credentials
const authUserPerson = async (req, res) => {
    try {
        const auth = req.body; // Get auth data from the request body

        if (!auth) {
            return res.status(400).json({ error: true });
        }

        const result = await authUserPersonQuery(auth); // Query to authenticate the user
        const user = result[0].recordset[0];            // Get the logged in user
        const role = result[1].recordset[0].ID_Role;    // Get the role of the logged in user

        if (!result) {
            return res.status(400).json({ error: true });
        };

        // Error if there is already an open session
        if (user.Active_Session) {
            return res.status(400).json({ error: true, activeSession: true });
        };

        // Check that the password matches
        const isMatch = await bcrypt.compare(auth.password, user.Password);

        if (!isMatch) {
            return res.status(400).json({ error: true });
        };

        // Check if the user has a temporary password
        const hasTempPassword = user.Temp_Password ? true : false;

        // Set the data of the open session
        const session = { idPerson: user.ID_Person, value: 1 };

        // Notify that the session is open
        const resultSession = await userPersonSessionQuery(session); 
        
        if (resultSession.rowsAffected[0] === 0) {
            return res.status(400).json({ error: true });
        };

        res.status(201).json({ error: false, idPerson: user.ID_Person, role: role, email: user.Email, hasTempPassword: hasTempPassword });
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Function to send a code to reset password
const sendCodeToResetPassword = async (req, res) => {
    try {
        const resetPassword = req.body; // Get resetPassword data from the request body
        if (!resetPassword) {
            return res.status(400).json({ error: true });
        }
        const usersPersons = await getUsersPersonsQuery();
        const validateUser = !!usersPersons.find(user => user.Username == resetPassword.username);
        if (!validateUser) {
            return res.status(400).json({ error: true, userNotFound: true });
        };

        const persons = await getPersonsQuery();
        const person = persons.find(person => person.Email == resetPassword.email);

        if (!person) {
            return res.status(400).json({ error: true, emailNotFound: true });
        };

        const personId = person.ID_Person;

        const subj = `Restablecimiento de contraseña para tu cuenta
                      en el portal del Instalador Inteligente`;
        const mess = `
        <p>Estimado(a) <strong>${resetPassword.username}</strong>,</p>
        
        <p>Hemos recibido una solicitud para restablecer la contraseña de tu cuenta en el sistema administrativo del Instalador Inteligente.</p>
        
        <p>A continuación, te proporcionamos una nueva contraseña temporal para que puedas acceder a tu cuenta:</p>
        
        <p><strong style="font-size: 18px;">Nueva contraseña temporal: ${resetPassword.tempPassword}</strong></p>
        
        <p><em>No responder este correo.</em></p>
        
        <p>Saludos cordiales,<br />
        El equipo de <strong>Zecu Consulting</strong>.</p>
        `;

        const result = await sendEmail(resetPassword.email, subj, mess); // Email sent
        res.status(200).json({ error: false, generatedCode: resetPassword.tempPassword, idPerson: personId })
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Create a new user
const createUserPerson = async (req, res) => {
    try {
        const user = req.body; // Get user data from the request body
        if (!user) {
            return res.status(400).send('Missing required field user person');
        };

        const allUsersPersons = await getUsersPersonsQuery();
        const userameExists = allUsersPersons.some(userPerson => { return userPerson.Username === user.username });
        if (userameExists) return res.status(400).json({ error: true, usernameExists: true });

        const hashedPassword = await bcrypt.hash(user.password, 10);         // Encrypt the password
        const hashedTempPassword = await bcrypt.hash(user.tempPassword, 10); // Encrypt the temporary password
        
        // Set the new user data
        const newUserPerson = {
            idPerson: user.idPerson,
            username: user.username,
            password: hashedPassword,
            tempPassword: hashedTempPassword
        };

        const result = await createUserPersonQuery(newUserPerson); // User is created

        if (result === 0) {
            return res.status(400).json({ error: true });
        }

        // Set the subject and message of the email
        const subj = `Tu cuenta en el portal administrativo del Instalador
                      Inteligente está lista - Aquí está tu clave de acceso`
        const mess = `
                      <p>Estimado(a) <strong>${user.username}</strong>,</p>
                    
                      <p>Te informamos que tu cuenta en el sistema administrativo del Instalador Inteligente ha sido creada exitosamente.</p>
                    
                      <p>A continuación, te proporcionamos tu clave de acceso generada automáticamente:</p>
                    
                      <p><strong style="font-size: 18px;">Clave de acceso: ${user.tempPassword}</strong></p>
                    
                      <p><em>No responder este correo.</em></p>
                    
                      <p>Saludos cordiales,<br />
                      El equipo de <strong>Zecu Consulting</strong>.</p>
                    `;

        await sendEmail(user.email, subj, mess); // Email sent

        res.status(201).json(user);
    } catch (err) {
        if (err.message === 'duplicated username') { // Duplicated username error
            return res.status(400).json({ error: true, usernameDuplicated: true });
        };
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Update existing user
const updateUserPerson = async (req, res) => {
    try {
        const id = req.params.id; // Get ID from params
        const user = req.body;    // Get user data from the request body

        if (!user) {
            return res.status(400).json({ error: true });
        };

        const hashedNewPassword = await bcrypt.hash(user.newPassword, 10); // Encrypt the password
        
        // Set the updated user
        const editUserPerson = {
            username: user.username,
            oldPassword: user.oldPassword,
            newPassword: hashedNewPassword,
            tempPassword: user.tempPassword
        };

        const result = await updateUserPersonQuery(id, editUserPerson); // User is updated

        if (result.rowsAffected[0] === 0) {
            return res.status(400).json({ error: true });
        };
        return res.status(201).json({ error: false });
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Update the temporal password
const updateTempPassword = async (req, res) => {
    try {
        const id = req.params.id; // Get ID from params
        const user = req.body;    // Get user data from the request body
        if (!user) {
            return res.status(400).json({ error: true });
        };

        const hashedPassword = await bcrypt.hash(user.tempPassword, 10);  // Encrypt the password
        const result = await updateTempPasswordQuery(id, hashedPassword); // TempPassword is updated

        if (result.rowsAffected[0] === 0) {
            return res.status(400).json({ error: true });
        };

        return res.status(201).json({ error: false });
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// Delete User
const deleteUserPerson = async (req, res) => {
    try {
        const id = req.params.id;                       // Get ID from params
        const result = await deleteUserPersonQuery(id); // User is deleted

        if (result === 0) {
            return res.status(404).json({ error: true });
        }

        return res.status(200).json({ error: false });
    } catch (err) {
        console.error('Server error:', err.message || err);
        res.status(500).json({ error: 'Server Error' });
    }
};


// Export the functions to be used in other modules
export {
    getUsersPersons,
    getUserPersonById,
    getUserPersonByIdInst,
    authUserPerson,
    userPersonSession,
    sendCodeToResetPassword,
    createUserPerson,
    updateUserPerson,
    updateTempPassword,
    deleteUserPerson
};