const express = require('express');
const bill_router = express.Router();
const bill_controller = require('../controllers/bill');
const path = require("path");

bill_router.post("/getProduct", bill_controller.getProduct);
bill_router.post("/createBill", bill_controller.createBill);
bill_router.post("/getBillDetail", bill_controller.getBillDetail);

module.exports = bill_router;