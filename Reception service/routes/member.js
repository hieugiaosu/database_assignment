const express = require('express');
const member_router = express.Router();
const member_controller = require('../controllers/member');
const path = require("path");

member_router.post("/list", member_controller.memberList);
member_router.post("/add", member_controller.memberAdd);

module.exports = member_router;