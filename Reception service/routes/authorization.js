const express = require('express');
const authorization_router = express.Router();
const authorization_controller = require('../controllers/authorization');
const path = require("path");

authorization_router.post("/collab", authorization_controller.collab);
authorization_router.post("/media", authorization_controller.media);
authorization_router.post("/content", authorization_controller.content);
authorization_router.post("/logistic", authorization_controller.logistic);
authorization_router.post("/admin", authorization_controller.admin);

module.exports = authorization_router;

