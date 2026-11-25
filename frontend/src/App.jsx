import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';

import LoginPage      from './pages/LoginPage';
import RegisterPage   from './pages/RegisterPage';
import OtpPage        from './pages/OtpPage';
import MenuPage       from './pages/MenuPage';
import OrdersPage     from './pages/OrdersPage';
import FeedbackPage   from './pages/FeedbackPage';
import RiderPage      from './pages/RiderPage';

import AdminOrdersPage   from './pages/AdminOrdersPage';
import AdminProductsPage from './pages/AdminProductsPage';
import AdminPromosPage   from './pages/AdminPromosPage';
import AdminRidersPage   from './pages/AdminRidersPage';
import AdminReportsPage  from './pages/AdminReportsPage';
import AdminFeedbackPage from './pages/AdminFeedbackPage';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/"  element={<Navigate to="/login" replace />} />

        {/* Auth */}
        <Route path="/login"    element={<LoginPage />} />
        <Route path="/register" element={<RegisterPage />} />
        <Route path="/otp"      element={<OtpPage />} />

        {/* Customer */}
        <Route path="/menu"     element={<MenuPage />} />
        <Route path="/orders"   element={<OrdersPage />} />
        <Route path="/feedback" element={<FeedbackPage />} />

        {/* Admin */}
        <Route path="/admin/orders"   element={<AdminOrdersPage />} />
        <Route path="/admin/products" element={<AdminProductsPage />} />
        <Route path="/admin/promos"   element={<AdminPromosPage />} />
        <Route path="/admin/riders"   element={<AdminRidersPage />} />
        <Route path="/admin/reports"  element={<AdminReportsPage />} />
        <Route path="/admin/feedback" element={<AdminFeedbackPage />} />

        {/* Rider */}
        <Route path="/rider" element={<RiderPage />} />

        {/* 404 */}
        <Route path="*" element={<Navigate to="/login" replace />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
