const { sequelize } = require("../models");

const getPrintingHistory = async (req, res) => {
  try {
    const results = await sequelize.query("CALL UserPrintingHistory()");

    res.json(results);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
const getPersonalPrintingHistory = async (req, res) => {
  try {
    const { id } = req.params;
    const results = await sequelize.query(
      `CALL PersonalPrintingHistory('${id}')`
    );

    res.json(results);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const getPrinterPrintingHistory = async (req, res) => {
  try {
    const { id } = req.params;
    const results = await sequelize.query(`CALL GetPrintingHistory('${id}')`);

    res.json(results);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
module.exports = {
  getPrintingHistory,
  getPersonalPrintingHistory,
  getPrinterPrintingHistory,
};
