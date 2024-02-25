import ReactDOM from "react-dom/client";
import { BrowserRouter, Routes, Route, Link, NavLink, Outlet } from "react-router-dom";
import $ from 'jquery';
import Popper from 'popper.js';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import axios from 'axios'
import { useState, useEffect } from "react";
import Header from '../shared/header'

const DiscountList = () => {
    const [discountList, setDiscountList] = useState([]);
    const [errMessage, setErrMessage] = useState(null);

    useEffect(() => {
        axios.post("/api/discount/list", {})
            .then((response) => { setDiscountList(response.data.discountList) })
            .catch((err) => { setErrMessage(err.response.data.message) })
    }, [])

    return (
        <div className="container mt-4">
            <h2>Danh sách khuyến mãi</h2>
            {errMessage && (<p className="text-danger fw-semibold">{errMessage}</p>)}
            <table className="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th>Mã khuyến mãi</th>
                        <th>Tên chương trình</th>
                        <th>Mô tả</th>
                        <th>Ngày bắt đầu</th>
                        <th>Ngày kết thúc</th>
                        <th>Điều kiện</th>
                        <th>Loại</th>
                        <th>Mức giảm</th>
                    </tr>
                </thead>
                <tbody>
                    {discountList.length > 0 && discountList.map((discount) => (
                        <tr key={discount.id}>
                            <td>{discount.id}</td>
                            <td>{discount.discountName}</td>
                            <td>{discount.description}</td>
                            <td>{discount.startDate}</td>
                            <td>{discount.endDate}</td>
                            <td>{discount.condition}</td>
                            <td>{discount.category}</td>
                            <td>{discount.discountValue}</td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
};

export default DiscountList;
