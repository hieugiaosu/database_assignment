import { NavLink, useNavigate } from "react-router-dom";
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import { useEffect, useState } from "react";
import Cookies from "universal-cookie";
import axios from "axios";


export default function Navbar(props) {
  const [authInfo, setAuthInfo] = useState({
    isLogin: false,
    isAdmin: false,
    isAdminMode: false
  });
  const cookies = new Cookies();
  const navigate = useNavigate();

  useEffect(() => {
    const token = cookies.get('TOKEN');
    console.log(`cookies: token=${token}`);
    if (token === undefined) {
      setAuthInfo(() => ({ isLogin: false, isAdmin: false, isAdminMode: false }));
    }
    else {
      axios
        .post('http://localhost:8080/api/authorization/collab', {}, {
          headers: {
            Authorization: `Bearer ${token}`
          }
        })
        .then((response) => {
          console.log(response.data);
          setAuthInfo({ isLogin: true, isAdmin: false, isAdminMode: false });
        })
        .catch((error) => {
          console.error(error);
          setAuthInfo({ isLogin: false, isAdmin: false, isAdminMode: false });
        });

      axios
        .post('http://localhost:8080/api/authorization/admin', {}, {
          headers: {
            Authorization: `Bearer ${token}`
          }
        })
        .then((response) => {
          console.log(response.data);
          setAuthInfo({ isLogin: true, isAdmin: true, isAdminMode: true });
        })
        .catch((error) => {

        });
    }
  }, []);

  const handleSignOut = (e) => {
    if (!authInfo.isLogin) {
      alert('Có lỗi xảy ra!');
      return;
    }
    cookies.remove('TOKEN', {
      path: "/",
    });
    setAuthInfo({ isLogin: false, isAdmin: false, isAdminMode: false });
    navigate('/');
    console.log('Đã đăng xuất');
  }

  let navItem1, navItem2, rightNavItem1, rightNavItem2;

  navItem1 = (
    <li className="nav-item dropdown">
      <NavLink
        className="nav-link dropdown-toggle"
        role="button"
        data-bs-toggle="dropdown"
        aria-expanded="false"
      >
        Hội viên
      </NavLink>
      <ul className="dropdown-menu">
        <li>
          <NavLink className="dropdown-item" to="/member">
            Danh sách
          </NavLink>
        </li>
        <li>
          <NavLink className="dropdown-item" to="/member/addMember">
            Thêm hội viên
          </NavLink>
        </li>
      </ul>
    </li>
  );
  navItem2 = (
    <li className="nav-item dropdown">
      <NavLink
        className="nav-link dropdown-toggle"
        role="button"
        data-bs-toggle="dropdown"
        aria-expanded="false"
      >
        Khuyến mãi
      </NavLink>
      <ul className="dropdown-menu">
        <li>
          <NavLink className="dropdown-item" to="/discount">
            Danh sách
          </NavLink>
        </li>
        <li>
          <NavLink className="dropdown-item" to="/discount/addDiscount">
            Thêm khuyến mãi
          </NavLink>
        </li>
        <li>
          <NavLink className="dropdown-item" to="/discount/discountForProduct">
            Tìm khuyến mãi cho sản phẩm
          </NavLink>
        </li>
      </ul>
    </li>
  );
  let navItem3 = (
    <li className="nav-item dropdown">
      <NavLink
        className="nav-link dropdown-toggle"
        role="button"
        data-bs-toggle="dropdown"
        aria-expanded="false"
      >
        Hoá đơn
      </NavLink>
      <ul className="dropdown-menu">
        <li>
          <NavLink className="dropdown-item" to="/bill/createBill">
            Tạo hoá đơn
          </NavLink>
        </li>
      </ul>
    </li>
  );
  let navItem4 = (
    <li className="nav-item dropdown">
      <NavLink
        className="nav-link dropdown-toggle"
        role="button"
        data-bs-toggle="dropdown"
        aria-expanded="false"
      >
        Dịch vụ khác cho lễ tân
      </NavLink>
      <ul className="dropdown-menu">
        <li>
          <NavLink className="dropdown-item" to="/otherService/storeSupervise">
            Giám sát cửa hàng
          </NavLink>
          <NavLink className="dropdown-item" to="/otherService/computerPriceLookup">
            Tìm giá và phụ thu máy tính
          </NavLink>
        </li>
      </ul>
    </li>
  );

  return (
    <nav className="navbar navbar-expand-lg bg-body-tertiary">
      <div className="container-fluid">
        <a className="navbar-brand" href="/">
          Quản lý
        </a>
        <button
          className="navbar-toggler"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#navbarSupportedContent"
          aria-controls="navbarSupportedContent"
          aria-expanded="false"
          aria-label="Toggle navigation"
        >
          <span className="navbar-toggler-icon" />
        </button>
        <div className="collapse navbar-collapse" id="navbarSupportedContent">
          <ul className="navbar-nav me-auto mb-2 mb-lg-0">
            {navItem1}
            {navItem2}
            {navItem3}
            {navItem4}
          </ul>
        </div>
      </div>
    </nav>

  );
}