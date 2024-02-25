import ReactDOM from "react-dom/client";
import { BrowserRouter, Routes, Route, Link, NavLink, Outlet } from "react-router-dom";
import $ from 'jquery';
import Popper from 'popper.js';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import axios from 'axios'
import { useState, useEffect } from "react";
import Header from '../shared/header'

const MemberAdd = () => {
  const [formData, setFormData] = useState({
    account: null,
    password: null,
    name: null,
    email: null,
    phoneNumber: null,
  });
  const [errMessage, setErrMessage] = useState(null);
  const [successMessage, setSuccessMessage] = useState(null);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prevData) => ({
      ...prevData,
      [name]: value,
    }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    axios.post("/api/member/add", { ...formData })
      .then((response) => { setSuccessMessage(response.data.message); setErrMessage(null) })
      .catch((err) => { setErrMessage(err.response.data.message); setSuccessMessage(null) })
  };

  return (
    <div className="container mt-4">
      <h2>Thêm hội viên</h2>
      {successMessage && (<p className="text-success fw-semibold">{successMessage}</p>)}
      {errMessage && (<p className="text-danger fw-semibold">{errMessage}</p>)}
      <form onSubmit={handleSubmit}>
        <div className="mb-3">
          <label htmlFor="account" className="form-label">
            Tài khoản
          </label>
          <input
            type="text"
            className="form-control"
            id="account"
            name="account"
            value={formData.account}
            onChange={handleChange}
          />
        </div>
        <div className="mb-3">
          <label htmlFor="password" className="form-label">
            Password
          </label>
          <input
            type="password"
            className="form-control"
            id="password"
            name="password"
            value={formData.password}
            onChange={handleChange}
          />
        </div>
        <div className="mb-3">
          <label htmlFor="memberName" className="form-label">
            Tên
          </label>
          <input
            type="text"
            className="form-control"
            id="memberName"
            name="name"
            value={formData.name}
            onChange={handleChange}
          />
        </div>
        <div className="mb-3">
          <label htmlFor="email" className="form-label">
            Email
          </label>
          <input
            type="email"
            className="form-control"
            id="email"
            name="email"
            value={formData.email}
            onChange={handleChange}
          />
        </div>
        <div className="mb-3">
          <label htmlFor="phoneNumber" className="form-label">
            Số điện thoại
          </label>
          <input
            type="tel"
            className="form-control"
            id="phoneNumber"
            name="phoneNumber"
            value={formData.phoneNumber}
            onChange={handleChange}
          />
        </div>
        <button type="submit" className="btn btn-primary">
          Thêm hội viên
        </button>
      </form>
    </div>
  );
};

export default MemberAdd;
