import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import personRoute from './routes/personRoute.js';
import userPersonRoute from './routes/userPersonRoute.js';
import trainingRoute from './routes/trainingRoute.js';
import countryRoute from './routes/countryRoute.js';
import rolePersonRoute from './routes/rolePersonRoute.js';
import engineRoute from './routes/engineRoute.js';
import activationRoute from './routes/activationRoute.js';
import engineTypeRoute from './routes/engineTypeRoute.js';
import validationRoute from './routes/validationRoute.js';
import membershipRoute from './routes/membershipRoute.js';
import roleRoute from './routes/roleRoute.js';
import path from 'path';

dotenv.config();

const port = process.env.PORT || 3000;
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'DELETE', 'UPDATE', 'PUT', 'PATCH']
}));

const __dirname = path.resolve();
app.use(express.static(path.join(__dirname, 'dist')));

app.use('/persons', personRoute);
app.use('/users-persons', userPersonRoute);
app.use('/trainings', trainingRoute);
app.use('/countries', countryRoute);
app.use('/role-persons', rolePersonRoute);
app.use('/engines', engineRoute)
app.use('/activations', activationRoute)
app.use('/engine-types', engineTypeRoute)
app.use('/validations', validationRoute)
app.use('/memberships', membershipRoute)
app.use('/roles', roleRoute)

app.get('*', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'dist', 'index.html'));
});

app.listen(port, () => {
  console.log(`App listening on port http://localhost:${port}`);
});
