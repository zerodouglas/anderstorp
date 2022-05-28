import { Navigate, Route, Routes } from 'react-router-dom';
import Layout from './components/Layout';
import IncidentReport from './components/IncidentReport';

function App() {
  return (
    <Layout>
      <Routes>
        <Route path="/incident/report" element={<IncidentReport />} />
        <Route
          path="*"
          element={<Navigate to="/incident/report" replace={true} />}
        />
      </Routes>
    </Layout>
  );
}

export default App;
