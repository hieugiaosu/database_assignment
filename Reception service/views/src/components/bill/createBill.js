import ReactDOM from "react-dom/client";
import { BrowserRouter, Routes, Route, Link, NavLink, Outlet } from "react-router-dom";
import $ from 'jquery';
import Popper from 'popper.js';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import axios from 'axios'
import { useState, useEffect } from "react";
import Header from '../shared/header'

const CreateBill = () => {
    const [formData, setFormData] = useState({
        memberId: null,
        employeeId: null,
    });

    const [searchKey, setSearchKey] = useState(null);
    const [searchResults, setSearchResults] = useState([]);
    const [addedProducts, setAddedProducts] = useState([]);
    const [quantityProduct, setQuantityProduct] = useState(null);
    const [submittedBill, setSubmittedBill] = useState(null);
    const [errMessage, setErrMessage] = useState(null);

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData((prevData) => ({
            ...prevData,
            [name]: value == '' ? null : value,
        }));
    };

    const handleSearch = (e) => {
        e.preventDefault();
        axios.post("/api/bill/getProduct", { productName: searchKey })
            .then((response) => { setSearchResults(response.data.productList); setErrMessage(null) })
            .catch((err) => { setErrMessage(err.response.data.message) });
    };

    const handleAddProduct = (productId, productName, productPrice) => {
        setAddedProducts((prevProducts) => [
            ...prevProducts,
            {
                productId: productId,
                quantity: quantityProduct,
                name: productName,
                price: productPrice,
                intoPrice: productPrice * quantityProduct
            },
        ]);
        setQuantityProduct(1);

    };

    const handleFormSubmit = (e) => {
        e.preventDefault();
        axios.post("/api/bill/createBill", { ...formData, productList: addedProducts })
            .then((respond) => {
                console.log(respond.data.createdBillId);
                axios.post("/api/bill/getBillDetail", { bill_id: respond.data.createdBillId })
                    .then((respond) => {
                        console.log(respond.data.billDetail);
                        setSubmittedBill(respond.data.billDetail);
                        setErrMessage(null);
                        setFormData({
                            memberId: null,
                            employeeId: null,
                        });
                        setAddedProducts([]);
                    })
                    .catch((err) => { setErrMessage(err.response.data.message) })
            })
            .catch((err) => { setErrMessage(err.response.data.message) })

    };

    return (
        <div className="container mt-4">
            <h2>Tạo hoá đơn mới</h2>
            {errMessage && (<p className="text-danger fw-semibold">{errMessage}</p>)}
            <form onSubmit={handleFormSubmit}>
                <div className="mb-3">
                    <label htmlFor="memberId" className="form-label">
                        Tài khoản hội viên
                    </label>
                    <input
                        type="text"
                        className="form-control"
                        id="memberId"
                        name="memberId"
                        value={formData.memberId}
                        onChange={handleChange}
                    />
                </div>
                <div className="mb-3">
                    <label htmlFor="employeeId" className="form-label">
                        ID Lễ tân
                    </label>
                    <input
                        type="text"
                        className="form-control"
                        id="employeeId"
                        name="employeeId"
                        value={formData.employeeId}
                        onChange={handleChange}
                    />
                </div>
                <button type="submit" className="btn btn-primary">
                    Tạo hoá đơn
                </button>
            </form>

            <hr />

            <form onSubmit={handleSearch} className="mb-3">
                <div className="input-group">
                    <input
                        type="text"
                        className="form-control"
                        placeholder="Tìm sản phẩm cần mua..."
                        value={searchKey}
                        onChange={(e) => setSearchKey(e.target.value)}
                    />
                    <button type="submit" className="btn btn-primary">
                        Tìm
                    </button>
                </div>
            </form>

            {searchResults.length > 0 && (
                <table className="table table-striped table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên sản phẩm</th>
                            <th>Giá</th>
                            <th>Số lượng trong kho</th>
                            <th>Số lượng cần mua</th>
                        </tr>
                    </thead>
                    <tbody>
                        {searchResults.map((result) => (
                            <tr key={result.productId}>
                                <td>{result.productId}</td>
                                <td>{result.name}</td>
                                <td>{result.price}</td>
                                <td>{result.instock}</td>
                                <td>
                                    <input
                                        type="number"
                                        value={quantityProduct}
                                        onChange={(e) => setQuantityProduct(e.target.value == '' ? null : e.target.value)}
                                    />
                                    <button
                                        type="button"
                                        className="btn btn-success btn-sm"
                                        onClick={() => handleAddProduct(result.productId, result.name, result.price)}
                                    >
                                        Thêm sản phẩm
                                    </button>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            )}

            <hr />

            {addedProducts.length > 0 && (
                <>
                    <h3>Sản phẩm đã thêm</h3>
                    <table className="table table-striped table-bordered table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên sản phẩm</th>
                                <th>Giá niêm yết</th>
                                <th>Số lượng cần mua</th>
                                <th>Thành tiền tạm tính (chưa áp dụng khuyến mãi)</th>
                            </tr>
                        </thead>
                        <tbody>
                            {addedProducts.map((addedProduct) => (
                                <tr key={addedProduct.productId}>
                                    <td>{addedProduct.productId}</td>
                                    <td>{addedProduct.name}</td>
                                    <td>{addedProduct.price}</td>
                                    <td>{addedProduct.quantity}</td>
                                    <td>{addedProduct.intoPrice}</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </>
            )}

            {submittedBill && (
                <div className="mt-4">
                    <h3>Chi tiết hoá đơn</h3>
                    <p>ID: {submittedBill.id}</p>
                    <p>Hội viên: {submittedBill.memberId}</p>
                    <p>Lễ tân: {submittedBill.employeeId}</p>
                    <p>Ngày thực hiện: {submittedBill.date}</p>
                    <p>Tổng tiền (đã áp dụng các khuyến mãi): {submittedBill.totalPrice}</p>
                    <h5>Các sản phẩm đã mua</h5>
                    <table className="table table-striped table-bordered table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên sản phẩm</th>
                                <th>Giá niêm yết</th>
                                <th>Số lượng cần mua</th>
                            </tr>
                        </thead>
                        <tbody>
                            {submittedBill.productList.map((productInBill) => (
                                <tr key={productInBill.productId}>
                                    <td>{productInBill.productId}</td>
                                    <td>{productInBill.name}</td>
                                    <td>{productInBill.price}</td>
                                    <td>{productInBill.quantity}</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            )}

        </div>
    );
};

export default CreateBill;
