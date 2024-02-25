import ReactDOM from "react-dom/client";
import { BrowserRouter, Routes, Route, Link, NavLink, Outlet } from "react-router-dom";
import $ from 'jquery';
import Popper from 'popper.js';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import axios from 'axios'
import { useState, useEffect } from "react";
import Header from '../shared/header'

const ComputerPriceLookup = () => {
    const [computerId, setComputerId] = useState(null);
    const [searchResults, setSearchResults] = useState([]);
    const [errMessage, setErrMessage] = useState(null);

    const handleSearch = () => {
        axios.post("/api/otherServices/getComputerPrice", { computerId: computerId })
            .then((response) => { setSearchResults(response.data.priceList); setErrMessage(null) })
            .catch((err) => { setErrMessage(err.response.data.message) })
    };

    return (
        <div className="container mt-4">
            <h2>Truy vấn giá và phụ thu cho máy</h2>
            {errMessage && (<p className="text-danger fw-semibold">{errMessage}</p>)}
            <div className="mb-3">
                <input
                    type="number"
                    className="form-control"
                    placeholder="Mã máy cần tìm thông tin..."
                    value={computerId}
                    onChange={(e) => setComputerId(e.target.value == '' ? null : e.target.value)}
                />
                <button
                    type="button"
                    className="btn btn-success btn-sm"
                    onClick={() => handleSearch()}
                >
                    Tìm thông tin
                </button>
            </div>

            {searchResults.length > 0 ? (
                <table className="table table-striped table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>Giá</th>
                            <th>Phụ thu</th>
                        </tr>
                    </thead>
                    <tbody>
                        {searchResults.map((computer) => (
                            <tr>
                                <td>{computer.price}</td>
                                <td>{computer.additionalCharge}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            ) : (
                <p>No results found.</p>
            )}
        </div>
    );
};

export default ComputerPriceLookup;
