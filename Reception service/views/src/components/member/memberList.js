import ReactDOM from "react-dom/client";
import { BrowserRouter, Routes, Route, Link, NavLink, Outlet } from "react-router-dom";
import $ from 'jquery';
import Popper from 'popper.js';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import axios from 'axios'
import { useState, useEffect } from "react";
import Header from '../shared/header'

function MemberList() {
  const [memberList, setMemberList] = useState([]);
  const [errMessage, setErrMessage] = useState(null);
  useEffect(() => {
    axios.post("/api/member/list", {})
      .then((response) => {
        console.log(response.data.memberList);
        setMemberList(response.data.memberList);
        setErrMessage(null);
      })
      .catch((err) => { setErrMessage(err.response.data.message) });
  }, [])
  return (
    <>
      <div className="container-md">
        <h3>Quản lý hội viên</h3>
        {errMessage && (<p className="text-danger fw-semibold">{errMessage}</p>)}
        <table className="table table-striped table-bordered table-hover">
          <thead>
            <tr>
              <th>Tên</th>
              <th>Email</th>
              <th>Level</th>
              <th>SĐT</th>
              <th>Số dư</th>
            </tr>
          </thead>
          <tbody>
            {memberList.length > 0 && memberList.map((rowData) => (
              <tr key={rowData.name}>
                <td>{rowData.name}</td>
                <td>{rowData.email}</td>
                <td>{rowData.level}</td>
                <td>{rowData.phoneNumber}</td>
                <td>{rowData.balance}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
export default MemberList