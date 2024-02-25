import { Link, useNavigate } from "react-router-dom";
import axios from 'axios'
import { useState, useEffect } from "react";
import Cookies from "universal-cookie";
const cookies = new Cookies();

function PublicTest() {
  const [commentFrame, setCommandFrame] = useState(null);
  const [memberConfig, setMemberConfig] = useState(null);
  
  const token = cookies.get("TOKEN");
  const navigate = useNavigate();
  useEffect(() => {
    axios
      .post("/api/authorization/collab", {}, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      })
      .then((response) => {
        console.log(response.data);
        setCommandFrame(
          <>
            <div className="mb-3">
              <label htmlFor="exampleInputCommandFrame" className="form-label">
                Khung bình luận (chỉ nên xuất hiện khi đã đăng nhập thành công)
              </label>
              <input
                type="email"
                className="form-control"
                id="exampleInputCommandFrame"
                aria-describedby="emailHelp"
              />
            </div>
            <button type="submit" className="btn btn-primary" onClick={() => { cookies.remove("TOKEN", { path: "/" }); navigate("/signin"); }}>
              Đăng xuất
            </button>
          </>
        );
      })
      .catch((error) => {
        console.error(error);
      });
    
    axios
      .post("/api/authorization/admin", {}, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      })
      .then((response) => {
        setMemberConfig(
          <button className="btn btn-primary">
            Nút chỉ nên được thấy bởi ban chủ nhiệm
          </button>
        );
      })
      .catch((error) => {
        console.error(error);
      });
  }, [])
  return (
    <>
      <h1>Đây là trang không cần đăng nhập cũng vào được</h1>
      <p>Tuy vậy, sẽ có những nội dung cần đăng nhập với quyền nhất định để thấy được</p>
      {commentFrame}
      {memberConfig}
    </>
  );
}

export default PublicTest;