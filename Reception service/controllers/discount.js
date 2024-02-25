const discount_model = require('../model/discount');

module.exports = {
    discountList: function (req, res) {
        discount_model.discountList(function (err, result) {
            if (err) {
                res.status(500).json({ message: err.message });
            }
            else {
                res.json({ discountList: result[0] });
            }
        })
    },
    discountAdd: function (req, res) {
        if (req.body.startDate == null) {
            res.status(400).json({ message: "Vui lòng chọn thời gian bắt đầu" });
            return;
        }
        if (req.body.endDate == null) {
            res.status(400).json({ message: "Vui lòng chọn thời gian kết thúc" });
            return;
        }
        let start_date = new Date(req.body.startDate);
        let end_date = new Date(req.body.endDate);
        let discount = {
            discountID: req.body.discountID,
            discountName: req.body.discountName,
            description: req.body.description,
            startDate: start_date.toISOString().split('T')[0] + ' ' + start_date.toTimeString().split(' ')[0],
            endDate: end_date.toISOString().split('T')[0] + ' ' + end_date.toTimeString().split(' ')[0],
            condition: req.body.condition,
            category: req.body.category,
            discountValue: req.body.discountValue,
        }
        discount_model.discountAdd(discount, function (err, result) {
            if (err) {
                res.status(500).json({ message: err.message });
            }
            else {
                res.json({ message: "Thêm khuyến mãi mới thành công!" })
            }
        })
    },
    discountForProduct: function(req, res) {
        discount_model.discountForProduct(req.body.productId, function(err, result) {
            if (err) {
                res.status(500).json({ message: err.message });
            }
            else {
                res.json({ discountForProduct: result[0] });
            }
        })
    }
}