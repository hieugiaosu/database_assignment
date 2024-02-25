const { luotin, tailieu, inan } = require("../models");
const { sequelize } = require("../models");

const printingSchedule = async (req, res) => {
    try {
        // Extracting the necessary data from request body
        const { userID, fileName, filePath, printDirection, pageCount, copyCount, printType, paperType, printerID, printTime } = req.body;

        const maxIdRow = await luotin.max('ID', {
            where: sequelize.where(sequelize.fn('length', sequelize.col('ID')), 6)
          });
      
          let nextIdNumber = 1;
          if (maxIdRow) {
            // Extract the numeric part and increment it
            const maxIdNumber = parseInt(maxIdRow.substring(2));
            nextIdNumber = maxIdNumber + 1;
          }
      
          // Generate the new ID with leading zeros
          const newluotinId = `LI${nextIdNumber.toString().padStart(4, '0')}`;

        // Creating a new printing session (luotin)
        const newluotin = await luotin.create({
            ID: newluotinId,
            ThoiGian: printTime,
            TinhTrang: 'Chờ xử lý',
            ID_QuanTriVien: null // Or any other relevant field values
        });

        // Finding the smallest available SttHangDoi
        const lastSttHangDoi = await tailieu.max('SttHangDoi');
        const sttHangDoi = lastSttHangDoi ? lastSttHangDoi + 1 : 1;

        // Creating a new document (tailieu)
        const newtailieu = await tailieu.create({
            Ten: fileName,
            ID_LuotIn: newluotinId,
            SoTrang: pageCount,
            SoBan: copyCount,
            LoaiGiay: paperType,
            HuongIn: printDirection,
            KieuIn: printType,
            QRCode: null, // Generate or handle QRCode if necessary
            FilePath: filePath,
            SttHangDoi: sttHangDoi
        });

        // Creating a new print job (inan)
        const newinan = await inan.create({
            ID_LuotIn: newluotinId,
            ID_MayIn: printerID,
            ID_NguoiDung: userID
        });

        res.status(200).json({
            message: "Print job scheduled successfully",
            // data: {
            //     luotIn: newluotin,
            //     taiLieu: newtailieu,
            //     inAn: newinan
            // }
        });
    } catch (error) {
        console.error('Error scheduling print job:', error);
        res.status(500).json({
            message: "Error scheduling print job",
            error: error.message
        });
    }
};

const getPrintingQueue = async (req, res) => {
    try {
        const { id } = req.params;
        const results = await sequelize.query(`CALL PrintingQueue('${id}')`);

        res.json(results);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

const getPrintedDocument = async (req, res) => {
    try {
        const { id } = req.params;
        const results = await sequelize.query(`CALL PrintedDocument('${id}')`);

        res.json(results);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = { printingSchedule, getPrintingQueue , getPrintedDocument};
