const express = require("express");
const routes = express.Router();
const authenticateToken = require("../middleware/authenticateToken");

const {
  getTotalPage,
  getTotalPrinter,
  getTotalPrints,
  addPrinter,
  getPrinterDetails,
  getPrinterByID,
  updatePrinterStatus,
  updatePrinterDetails,
  deletePrinter,
} = require("../controllers/printerController");

// Number of printers
routes.get("/total", authenticateToken, getTotalPrinter);
// Number of pages
routes.get("/totalpage", authenticateToken, getTotalPage);
// Number of prints
routes.get("/totalprints", authenticateToken, getTotalPrints);
// Number of queue
// routes.get('/totalqueue', getTotalQueue);

// Add printer
routes.post("/", authenticateToken, addPrinter);

// Get printer details
routes.get("/", authenticateToken, getPrinterDetails);

// Get printer details by ID
routes.get("/:id", authenticateToken, getPrinterByID);
// Update printer status
routes.put("/:id/status", authenticateToken, updatePrinterStatus);
// Update printer details
routes.put("/:id", authenticateToken, updatePrinterDetails);
// Delete printer
routes.delete("/:id", authenticateToken, deletePrinter);

module.exports = routes;
