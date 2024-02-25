import ReactDOM from "react-dom/client";
import { BrowserRouter, Routes, Route, Link, NavLink, Outlet } from "react-router-dom";
import $ from 'jquery';
import Popper from 'popper.js';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import axios from 'axios'
import { useState, useEffect } from "react";
import Header from '../shared/header'

const DiscountAdd = () => {
    const [formData, setFormData] = useState({
        discountID: null,
        discountName: null,
        description: null,
        startDate: null,
        endDate: null,
        condition: null,
        category: null,
        discountValue: null,
    });

    const [errMessage, setErrMessage] = useState(null);
    const [successMessage, setSuccessMessage] = useState(null);

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData((prevData) => ({
            ...prevData,
            [name]: value == '' ? null : value,
        }));
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        axios.post("/api/discount/add", { ...formData })
            .then((response) => { setSuccessMessage(response.data.message); setErrMessage(null) })
            .catch((err) => { setErrMessage(err.response.data.message); setSuccessMessage(null) })
    };

    return (
        <div className="container mt-4">
            <h2>Thêm chương trình khuyến mãi mới</h2>
            {successMessage && (<p className="text-success fw-semibold">{successMessage}</p>)}
            {errMessage && (<p className="text-danger fw-semibold">{errMessage}</p>)}
            <form onSubmit={handleSubmit}>
                <div className="mb-3">
                    <label htmlFor="discountID" className="form-label">
                        Mã khuyến mãi
                    </label>
                    <input
                        type="number"
                        className="form-control"
                        id="discountID"
                        name="discountID"
                        value={formData.discountID}
                        onChange={handleChange}
                    />
                </div>
                <div className="mb-3">
                    <label htmlFor="discountName" className="form-label">
                        Tên chương trình
                    </label>
                    <input
                        type="text"
                        className="form-control"
                        id="discountName"
                        name="discountName"
                        value={formData.discountName}
                        onChange={handleChange}
                    />
                </div>
                <div className="mb-3">
                    <label htmlFor="description" className="form-label">
                        Mô tả
                    </label>
                    <textarea
                        className="form-control"
                        id="description"
                        name="description"
                        value={formData.description}
                        onChange={handleChange}
                    />
                </div>
                <div className="mb-3">
                    <label htmlFor="startDate" className="form-label">
                        Ngày bắt đầu
                    </label>
                    <input
                        type="datetime-local"
                        className="form-control"
                        id="startDate"
                        name="startDate"
                        value={formData.startDate}
                        onChange={handleChange}
                    />
                </div>
                <div className="mb-3">
                    <label htmlFor="endDate" className="form-label">
                        Ngày kết thúc
                    </label>
                    <input
                        type="datetime-local"
                        className="form-control"
                        id="endDate"
                        name="endDate"
                        value={formData.endDate}
                        onChange={handleChange}
                    />
                </div>
                <div className="mb-3">
                    <label htmlFor="condition" className="form-label">
                        Điều kiện
                    </label>
                    <input
                        type="number"
                        className="form-control"
                        id="condition"
                        name="condition"
                        value={formData.condition}
                        onChange={handleChange}
                    />
                </div>
                <div className="mb-3">
                    <label htmlFor="category" className="form-label">
                        Loại
                    </label>
                    <input
                        type="text"
                        className="form-control"
                        id="category"
                        name="category"
                        value={formData.category}
                        onChange={handleChange}
                    />
                </div>
                <div className="mb-3">
                    <label htmlFor="discountValue" className="form-label">
                        Mức giảm
                    </label>
                    <input
                        type="number"
                        step={0.01}
                        className="form-control"
                        id="discountValue"
                        name="discountValue"
                        value={formData.discountValue}
                        onChange={handleChange}
                    />
                </div>
                <button type="submit" className="btn btn-primary">
                    Thêm
                </button>
            </form>
        </div>
    );
};

export default DiscountAdd;

