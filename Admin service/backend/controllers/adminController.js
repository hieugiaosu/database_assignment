const jwt = require("jsonwebtoken");
const jwtConfig = require("../config/auth.js");
const authenticateToken = require("../middleware/authenticateToken");
const { quantrivien } = require("../models");
const bcrypt = require("bcrypt");
const cookieParser = require("cookie-parser");

const generateAccessToken = (admin) => {
  const accessToken = jwt.sign({ adminId: admin.ID }, jwtConfig.secret, {
    expiresIn: "20h", // 20s for testing, 15m for production
  });
  const refreshToken = jwt.sign(
    { adminId: admin.ID },
    jwtConfig.refreshSecret,
    {
      expiresIn: "24h",
    }
  );
  return { accessToken, refreshToken };
};

const updateRefreshToken = async (username, refreshToken) => {
  try {
    await quantrivien.update(
      { RefreshToken: refreshToken },
      { where: { TenDangNhap: username } }
    );
  } catch (error) {
    console.error("Error updating refresh token:", error);
    throw error;
  }
};

const adminLoginController = async (req, res) => {
  const { username, password } = req.body;
  try {
    const admin = await quantrivien.findOne({
      where: { TenDangNhap: username },
    });
    if (admin && bcrypt.compareSync(password, admin.MatKhau)) {
      const tokens = generateAccessToken(admin);
      await updateRefreshToken(username, tokens.refreshToken);

      // Đặt refreshToken vào cookie HTTP Only
      res.cookie("refreshToken", tokens.refreshToken, {
        httpOnly: true, // Chỉ có thể truy cập bởi server
        secure: true, // Gửi cookie chỉ qua HTTPS
        sameSite: "Strict", // Chống CSRF
        path: "/auth/token", // Cookie sẽ được gửi đến các request tới '/auth/token'
      });

      // Trả về accessToken trong phản hồi JSON
      res.json({
        accessToken: tokens.accessToken,
        admin: {
          ID: admin.ID,
          Ten: admin.Ten,
          TenDangNhap: admin.TenDangNhap,
          ChucVu: admin.ChucVu,
        },
      });
    } else {
      res.status(401).send("Username or password incorrect");
    }
  } catch (error) {
    console.error("Login error:", error);
    res.status(500).send("An error occurred during login");
  }
};

const adminTokenController = async (req, res) => {
  // Lấy refreshToken từ cookie thay vì từ body
  const refreshToken = req.cookies.refreshToken;
  if (!refreshToken) return res.sendStatus(401);

  try {
    const decoded = jwt.verify(refreshToken, jwtConfig.refreshSecret);
    const admin = await quantrivien.findOne({
      where: { ID: decoded.adminId, RefreshToken: refreshToken },
    });

    if (!admin) return res.sendStatus(403);

    const tokens = generateAccessToken(admin);
    await updateRefreshToken(admin.TenDangNhap, tokens.refreshToken);

    // Đặt lại refreshToken trong cookie
    res.cookie("refreshToken", tokens.refreshToken, {
      httpOnly: true,
      secure: true,
      sameSite: "Strict",
      path: "/auth/token",
    });

    // Trả về accessToken mới
    res.json({ accessToken: tokens.accessToken });
  } catch (err) {
    console.log(err);
    return res.sendStatus(500);
  }
};

const adminLogoutController = async (req, res) => {
  try {
    const adminId = req.user.adminId;
    // console.log(req.user);
    await quantrivien.update(
      { RefreshToken: null },
      { where: { ID: adminId } }
    );
    res.status(200).send("Logout successful");
  } catch (err) {
    console.log(err);
    res.status(500).send("An error occurred during logout");
  }
};

module.exports = {
  adminLoginController,
  adminTokenController,
  adminLogoutController,
};
