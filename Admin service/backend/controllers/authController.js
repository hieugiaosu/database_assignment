const jwt = require("jsonwebtoken");
const jwtConfig = require("../config/auth.js");
const authenticateToken = require("../middleware/authenticateToken");
const { nguoidung } = require("../models");
const bcrypt = require("bcrypt");
const cookieParser = require("cookie-parser");

const generateAccessToken = (user) => {
  const accessToken = jwt.sign({ userId: user.ID }, jwtConfig.secret, {
    expiresIn: "20h", // 20s for testing, 15m for production
  });
  const refreshToken = jwt.sign({ userId: user.ID }, jwtConfig.refreshSecret, {
    expiresIn: "24h",
  });
  return { accessToken, refreshToken };
};

const updateRefreshToken = async (username, refreshToken) => {
  try {
    await nguoidung.update(
      { RefreshToken: refreshToken },
      { where: { TenDangNhap: username } }
    );
  } catch (error) {
    console.error("Error updating refresh token:", error);
    throw error;
  }
};

const loginController = async (req, res) => {
  const { username, password } = req.body;
  try {
    const user = await nguoidung.findOne({
      where: { TenDangNhap: username },
    });
    if (user && bcrypt.compareSync(password, user.MatKhau)) {
      const tokens = generateAccessToken(user);
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
        user: {
          ID: user.ID,
          Ten: user.Ten,
          TenDangNhap: user.TenDangNhap,
          VaiTro: user.VaiTro,
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

const tokenController = async (req, res) => {
  // Lấy refreshToken từ cookie thay vì từ body
  const refreshToken = req.cookies.refreshToken;
  if (!refreshToken) return res.sendStatus(401);

  try {
    const decoded = jwt.verify(refreshToken, jwtConfig.refreshSecret);
    const user = await nguoidung.findOne({
      where: { ID: decoded.userId, RefreshToken: refreshToken },
    });

    if (!user) return res.sendStatus(403);

    const tokens = generateAccessToken(user);
    await updateRefreshToken(user.TenDangNhap, tokens.refreshToken);

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

const logoutController = async (req, res) => {
  try {
    console.log(req.user);
    const userId = req.user.userId;

    if (!userId) return res.sendStatus(403).send("User not found");

    await nguoidung.update({ RefreshToken: null }, { where: { ID: userId } });
    res.status(200).send("Logout successful");
  } catch (err) {
    console.log(err);
    res.status(500).send("An error occurred during logout");
  }
};

const registerController = async (req, res) => {
  const { username, password, name, role } = req.body;

  try {
    const userExists = await nguoidung.findOne({
      where: { TenDangNhap: username },
    });
    if (userExists) {
      return res.status(400).send("Username already exists");
    }

    // Hash the password
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(password, saltRounds);

    const newUser = await nguoidung.create({
      ID: "ND" + Date.now(), // Unique ID generation
      Ten: name,
      TenDangNhap: username,
      MatKhau: hashedPassword,
      VaiTro: role,
    });

    res.status(201).json({
      message: "User registered successfully",
      user: {
        ID: newUser.ID,
        Ten: newUser.Ten,
        TenDangNhap: newUser.TenDangNhap,
        VaiTro: newUser.VaiTro,
      },
    });
  } catch (error) {
    console.error("Register error:", error);
    res.status(500).send("An error occurred during registration");
  }
};

module.exports = {
  loginController,
  tokenController,
  logoutController,
  registerController,
};
