const express = require("express");
const routes = express.Router();
const authenticateToken = require("../middleware/authenticateToken");

const {
  printingSchedule,
  getPrintingQueue,
  getPrintedDocument,
} = require("../controllers/printingController");

routes.post("/", authenticateToken, printingSchedule);

routes.get("/queue/:id", authenticateToken, getPrintingQueue);

routes.get("/done/:id", authenticateToken, getPrintedDocument);

module.exports = routes;
