const express = require("express");
const routes = express.Router();
const authenticateToken = require("../middleware/authenticateToken");

const {
adminLoginController,
adminTokenController,
adminLogoutController,
} = require("../controllers/adminController");


routes.post("/login", adminLoginController);

routes.post("/token", adminTokenController);
routes.delete("/logout", authenticateToken, adminLogoutController);

module.exports = routes;
