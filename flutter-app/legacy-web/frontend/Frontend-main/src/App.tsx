import { useEffect, useState } from 'react';
import { Route, Routes, useLocation, Navigate } from 'react-router-dom';
import Loader from './common/Loader';
import PageTitle from './components/PageTitle';
import Home from './pages/Dashboard/Home';
import DefaultLayout from './layout/DefaultLayout';
import TablePerson from './components/Tables/TablePerson';
import TableEngine from './components/Tables/TableEngine';
import TableCountry from './components/Tables/TableCountry';
import TableActivation from './components/Tables/TableActivation';
import TableUserPerson from './components/Tables/TableUserPerson';
import TableRolePerson from './components/Tables/TableRolePerson';
import TableValidation from './components/Tables/TableValidation';
import TableEngineType from './components/Tables/TableEngineType';
import TableTraining from './components/Tables/TableTraining';
import TableMembership from './components/Tables/TableMembership';
import Login from './components/Login/Login';
import ResetPassword from './components/ResetPassword/ResetPassword';
import { ToastContainer } from 'react-toastify';
import { UserLogin } from './interfaces/Interfaces';
import { getCurrentUser } from './utils/utils';
import NotFound from './components/NotFound/NotFound';
import ResetPasswordNotLogged from './components/ResetPassword/ResetPasswordNotLogged';
import { destroyActiveSession } from './utils/utils';

function App() {
  const [loading, setLoading] = useState<boolean>(true);
  const { pathname } = useLocation();
  const [logged, setLogged] = useState<boolean>(false);
  const [currentUser, setCurrentUser] = useState<UserLogin | null>(null);
  const [searchedData, setSearchedData] = useState<string | null>(null);

  const current = getCurrentUser();

  // Retrieve from localStorage
  useEffect(() => {
    const storedLogged = localStorage.getItem('logged');
    const storedUser = localStorage.getItem('currentUser');

    setLogged(storedLogged === 'true');

    if (storedUser) {
      try {
        const user = JSON.parse(storedUser);
        setCurrentUser(user);
      } catch (error) {
        setCurrentUser(null);
      }
    } else {
      setCurrentUser(null);
    }
  }, []);

  // Scroll to top on path change
  useEffect(() => {
    window.scrollTo(0, 0);
  }, [pathname]);

  // Simulate loading
  useEffect(() => {
    setTimeout(() => setLoading(false), 1000);
  }, []);

  // Handle login
  const handleLogin = (user: UserLogin) => {
    localStorage.setItem('logged', 'true');
    localStorage.setItem('currentUser', JSON.stringify(user));
    setLogged(true);
  };

  // Handle logout
  const handleLogout = async () => {
    await destroyActiveSession(current.ID_Person);
    localStorage.removeItem('logged');
    localStorage.removeItem('currentUser');
    setLogged(false);
    setCurrentUser(null);
  };

  if (!logged) return (
    <>
      <ToastContainer />
      <Routes>
      <Route
          path="/reset-password-user"
          element={
            <>
              <PageTitle title="Cambiar contraseña" />
              <ResetPasswordNotLogged />
            </>
          }
        />
        <Route
          path='/login'
          element={
            <Login handleLogin={handleLogin} />}
        >
        </Route>
        <Route
          path='*'
          element={
            <Login handleLogin={handleLogin} />}
        >
        </Route>
      </Routes>
    </>
  );

  return loading ? (
    <Loader />
  ) : (
    <DefaultLayout handleLogout={handleLogout} setSearchedData={setSearchedData}>
      <ToastContainer />
      <Routes>
        <Route
          index
          element={
            <>
              <PageTitle title="Instalador Inteligente" />
              <Home />
            </>
          }
        />
        <Route
          path="/tables/persons"
          element={
            <>
              <PageTitle title="Personas" />
              <TablePerson searchedData={searchedData} />
            </>
          }
        />
        <Route
          path="/tables/countries"
          element={
            current.ID_Role === 1 ? (
              <>
                <PageTitle title="Países" />
                <TableCountry searchedData={searchedData} />
              </>
            ) : (
              <Navigate to="/" />
            )
          }
        />
        <Route
          path="/tables/engines"
          element={
            <>
              <PageTitle title="Motores" />
              <TableEngine searchedData={searchedData} />
            </>
          }
        />
        <Route
          path="/tables/engine-types"
          element={
            <>
              <PageTitle title="Tipos de Motor" />
              <TableEngineType searchedData={searchedData} />
            </>
          }
        />
        <Route
          path="/tables/memberships"
          element={
            <>
              <PageTitle title="Membresías" />
              <TableMembership searchedData={searchedData} />
            </>
          }
        />
        <Route
          path="/tables/validations"
          element={
            <>
              <PageTitle title="Validaciones" />
              <TableValidation searchedData={searchedData} />
            </>
          }
        />
        <Route
          path="/tables/trainings"
          element={
            <>
              <PageTitle title="Entrenamientos" />
              <TableTraining searchedData={searchedData} />
            </>
          }
        />
        <Route
          path="/tables/activations"
          element={
            <>
              <PageTitle title="Activaciones" />
              <TableActivation searchedData={searchedData} />
            </>
          }
        />
        <Route
          path="/reset-password"
          element={
            <>
              <PageTitle title="Cambiar contraseña" />
              <ResetPassword handleLogout={handleLogout}/>
            </>
          }
        />
        <Route
          path="/tables/user-person"
          element={
            <>
              <PageTitle title="Usuarios" />
              <TableUserPerson searchedData={searchedData} />
            </>
          }
        />
        <Route
          path="/tables/role-person"
          element={
            <>
              <PageTitle title="Roles" />
              <TableRolePerson searchedData={searchedData} />
            </>
          }
        />
        <Route
          path="/auth/signin"
          element={
            <>
              <PageTitle title="Inicio de sesión" />
            </>
          }
        />
        <Route
          path="*"
          element={
            <>
              <PageTitle title="" />
              <NotFound />
            </>
          }
        />
      </Routes>
    </DefaultLayout>
  );
}

export default App;
