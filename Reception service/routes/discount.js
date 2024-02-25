const express = require('express');
const discount_router = express.Router();
const discount_controller = require('../controllers/discount');
const path = require("path");

discount_router.post("/list", discount_controller.discountList);
discount_router.post("/add", discount_controller.discountAdd);
discount_router.post("/forProduct", discount_controller.discountForProduct);

module.exports = discount_router;