import ReactDOM from "react-dom/client";
import { BrowserRouter, Routes, Route, Link, NavLink, Outlet, Navigate, useNavigate } from "react-router-dom";
import $ from 'jquery';
import Popper from 'popper.js';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import axios from 'axios'
import { useState, useEffect } from "react";
import Header from '../shared/header';
import Cookies from "universal-cookie";
const cookies = new Cookies();

function PrivateRoutes(prop) {
    const token = cookies.get("TOKEN");
    const navigate = useNavigate();
    const [decision, setDecision] = useState(null);
    useEffect(() => {
        if (!token) {
            setDecision(<Navigate to={"/signin"} />);
        }
        else {
            let url = "/api/authorization/" + prop.validatePermission;
            axios.post(url, {}, {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            }).then((response) => {
                setDecision(<Outlet />);

            }).catch((error) => {
                setDecision(<Navigate to={"/signin"} />);
            });
        }
    }, [])
    return decision;
}

export default PrivateRoutes;