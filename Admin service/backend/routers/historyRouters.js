const express = require("express");
const routes = express.Router();
const authenticateToken = require("../middleware/authenticateToken");

const {
  getPrintingHistory,
  getPersonalPrintingHistory,
  getPrinterPrintingHistory,
} = require("../controllers/historyController");

routes.get("/", authenticateToken, getPrintingHistory);

routes.get("/:id", authenticateToken, getPersonalPrintingHistory);

routes.get("/printer/:id", authenticateToken, getPrinterPrintingHistory);

module.exports = routes;
