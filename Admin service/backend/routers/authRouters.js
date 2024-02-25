const express = require("express");
const routes = express.Router();
const authenticateToken = require("../middleware/authenticateToken");

const {
  loginController,
  tokenController,
  logoutController,
  registerController,
} = require("../controllers/authController");

routes.post("/register", registerController);

routes.post("/login", loginController);

routes.post("/token", tokenController);
routes.delete("/logout", authenticateToken, logoutController);

module.exports = routes;
