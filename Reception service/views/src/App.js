import './App.css';
import ReactDOM from "react-dom/client";
import { BrowserRouter, Routes, Route, Link, NavLink, Outlet } from "react-router-dom";
import $ from 'jquery';
import Popper from 'popper.js';
import Header from './components/shared/header'
import MemberList from './components/member/memberList';
import NoPage from './components/nopage/nopage';
import SignIn from './components/signin/signin'
import axios from 'axios'
import PrivateRoutes from './components/shared/private_routes';
import ProtectedTest from './components/(test_only)protected_test/protected_test';
import PublicTest from './components/(test_only)public_test/public_test';
import SignUp from './components/signup/signup';
import MemberAdd from './components/member/memberAdd';
import DiscountList from './components/discount/discountList';
import DiscountAdd from './components/discount/discountAdd';
import CreateBill from './components/bill/createBill';
import DiscountForProduct from './components/discount/discountForProduct';
import StoreSupervise from './components/otherServices/storeSupervise';
import ComputerPriceLookup from './components/otherServices/computerPriceLookup';

function App() {
  return (
    <Routes>
      <Route path="/" element={<Header />}>
        <Route index element={<MemberList />} />
        <Route path='member'>
          <Route index element={<MemberList />} />
          <Route path='addMember' element={<MemberAdd />} />
        </Route>
        <Route path='discount'>
          <Route index element={<DiscountList />} />
          <Route path='addDiscount' element={<DiscountAdd />} />
          <Route path='discountForProduct' element={<DiscountForProduct />} />
        </Route>
        <Route path='bill'>
          <Route path='createBill' element={<CreateBill />} />
        </Route>
        <Route path='otherService'>
          <Route path='storeSupervise' element={<StoreSupervise />} />
          <Route path='computerPriceLookup' element={<ComputerPriceLookup />} />
        </Route>
        <Route path='signin' element={<SignIn />} />
        <Route path='signup' element={<SignUp />} />
        <Route path='publicTest' element={<PublicTest />} />
        <Route element={<PrivateRoutes validatePermission={"admin"} />} >
          <Route path='protectedTest' element={<ProtectedTest />} />
        </Route>
        <Route path="*" element={<NoPage />} />
      </Route>
    </Routes>
  );
}

export default App;

