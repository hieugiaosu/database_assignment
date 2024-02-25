const path = require("path");
const authorization_model = require('../model/authorization');

module.exports = {
  collab: [authorization_model.loadCurMember, authorization_model.authorizeCollaborator, function (req, res) {
    res.status(200).json({});
  }],
  media: [authorization_model.loadCurMember, authorization_model.authorizeMediaMember, function (req, res) {
    res.status(200).json({});
  }],
  content: [authorization_model.loadCurMember, authorization_model.authorizeContentMember, function (req, res) {
    res.status(200).json({});
  }],
  logistic: [authorization_model.loadCurMember, authorization_model.authorizeLogisticMember, function (req, res) {
    res.status(200).json({});
  }],
  admin: [authorization_model.loadCurMember, authorization_model.authorizeAdmin, function (req, res) {
    res.status(200).json({});
  }],
}