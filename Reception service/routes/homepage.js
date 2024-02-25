const express = require('express');
const homepage_router = express.Router();
const homepage_controller = require('../controllers/homepage');
const path = require("path");

homepage_router.get("/", homepage_controller.load);

module.exports = homepage_router;