const { cauhinh, khuvuc, maytinh } = require("../models");

const getTotalPrinter = async (req, res) => {
  try {
    const count = await maytinh.count();
    res.json(count);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const getTotalPage = async (req, res) => {
  try {
    const count = await khuvuc.count();
    res.json(count);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const getTotalPrints = async (req, res) => {
  try {
    const count = await cauhinh.count();
    res.json(count);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const addPrinter = async (req, res) => {
  try {
    const printer = await maytinh.create(req.body);
    res.json({ message: "Computer added successfully", ID: printer.ID });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const getPrinterDetails = async (req, res) => {
  try {
    const printers = await maytinh.findAll({
      attributes: [
        "ID",
        "hang",
        "id cau hinh",
        "ngay mua",
        "phan loai khu vuc",
      ],
    });
    res.json(printers);
    console.log(printers);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const getPrinterByID = async (req, res) => {
  try {
    const { id } = req.params;
    const printer = await maytinh.findByPk(id);
    if (!printer) {
      return res.status(404).json({ message: "Printer not found" });
    }
    res.json(printer);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const updatePrinterStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const printer = await maytinh.findByPk(id);
    if (!printer) {
      return res.status(404).json({ message: "Printer not found" });
    }
    printer.TinhTrang = printer.TinhTrang == "Working" ? "Disabled" : "Working";
    await printer.save();
    res.json({
      message: "Printer saved successfully",
      ID: printer.ID,
      TinhTrang: printer.TinhTrang,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const updatePrinterDetails = async (req, res) => {
  try {
    const { id } = req.params;
    const printer = await maytinh.findByPk(id);
    if (!printer) {
      return res.status(404).json({ message: "Printer not found" });
    }
    printer.hang = req.body.hang;
    printer["ngay mua"] = req.body["ngay mua"];
    printer["phan loai khu vuc"] = req.body["phan loai khu vuc"];
    printer["id cau hinh"] = req.body["id cau hinh"];

    await printer.save();
    res.json({ message: "Printer saved successfully", ID: printer.ID });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const deletePrinter = async (req, res) => {
  try {
    const { id } = req.params;
    const printer = await maytinh.findByPk(id);
    if (!printer) {
      return res.status(404).json({ message: "Printer not found" });
    }
    await printer.destroy();
    res.json({ message: "Printer deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  getTotalPage,
  getTotalPrinter,
  getTotalPrints,
  addPrinter,
  getPrinterDetails,
  getPrinterByID,
  updatePrinterStatus,
  updatePrinterDetails,
  deletePrinter,
};
