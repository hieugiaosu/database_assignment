const express = require('express');
const otherServices_router = express.Router();
const otherServices_controller = require('../controllers/otherServices');
const path = require("path");

otherServices_router.post("/getComputerPrice", otherServices_controller.getComputerPrice);
otherServices_router.post("/sessionList", otherServices_controller.sessionList);
otherServices_router.post("/sessionSearchByMember", otherServices_controller.sessionSearchByMember);
otherServices_router.post("/sessionSearchByComputer", otherServices_controller.sessionSearchByComputer);

module.exports = otherServices_router;