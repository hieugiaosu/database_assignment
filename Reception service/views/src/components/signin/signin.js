import { Link, Navigate, useNavigate } from "react-router-dom";
import axios from "axios";
import { useState, useEffect } from "react";
import Cookies from "universal-cookie";

const cookies = new Cookies();

function SignIn() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [errorMessage, setErrorMessage] = useState(null);
  
  const navigate = useNavigate();
  
  const handleSubmit = (e) => {
    e.preventDefault();
    axios
      .post("http://localhost:8080/api/signin", {
        email: email,
        password: password,
      })
      .then((response) => {
        cookies.set("TOKEN", response.data.token, {
          path: "/",
        });
        setTimeout(() => {
          window.location.reload();
        }, 500);
        navigate("/");
      })
      .catch((error) => {
        if (error.response) {
          setErrorMessage(error.response.data.message);
        }
      });
  };
  
  return (
    <div className='container-sm'>
      <div className='row justify-content-center align-items-center py-4'>
        <div 
          className='col col-sm-9 col-md-7 col-lg-6 col-xl-4 bg-light p-4 p-lg-5 rounded'
          style={{
            boxShadow: '0rem 0.5rem 1rem rgba(0, 0, 0, 0.15)'
          }}
        >
          <div className='row text-center px-4 px-lg-0'>
            <h1 className='col-12'>Đăng nhập</h1>
            <div className='col-12 border-top my-3'></div>
            <div className="col-12">
              <form onSubmit={(e) => handleSubmit(e)}>
                <div className="mb-3 text-start">
                  <label htmlFor="email" className="form-label h6">Email</label>
                  <input
                    type="email"
                    className="form-control"
                    id="email"
                    name="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                  />
                </div>
                <div className="mb-3 text-start">
                  <label htmlFor="password" className="form-label h6">Mật khẩu</label>
                  <input
                    type="password"
                    className="form-control"
                    id="password"
                    name="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                  />
                </div>
                <button
                  type="submit"
                  className="btn btn-primary mt-4"
                >
                  Đăng nhập
                </button>
                {errorMessage &&
                  <h5 className="mt-3 mb-0 p-0 text-danger">{errorMessage}</h5>
                }
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
export default SignIn;
