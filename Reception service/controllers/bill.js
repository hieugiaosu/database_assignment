const bill_model = require('../model/bill');

module.exports = {
    getProduct: function (req, res) {
        bill_model.getProduct(req.body.productName, function (err, result) {
            if (err) {
                res.status(500).json({ message: err.message })
            }
            else {
                res.json({ productList: result[0] });
            }
        })
    },
    createBill: function (req, res) {
        let billInfo = {
            memberId: req.body.memberId,
            employeeId: req.body.employeeId
        };
        bill_model.createBill(billInfo, function (err, result) {
            if (err) {
                res.status(500).json({ message: err.message })
            }
            else {
                let bill_id = result[0][0].insertId;
                let currentIndex = 0;

                function insertNextProduct() {
                    if (currentIndex < req.body.productList.length) {
                        const productInfo = req.body.productList[currentIndex];
                        bill_model.insertProductToBill(bill_id, productInfo, function (err, result) {
                            if (err) {
                                if (err.code == 45000) {
                                    console.log(err.message);
                                    currentIndex++;
                                    insertNextProduct();
                                }
                                else {
                                    res.status(500).json({ message: err.message });
                                }
                            }
                            else {
                                currentIndex++;
                                insertNextProduct();
                            }
                        })

                    } else {
                        bill_model.applyDiscountToBill(bill_id, function (err, result) {
                            if (err) {
                                res.status(500).json({ message: err.message });
                            }
                            else {
                                res.json({ createdBillId: bill_id });
                            }
                        })
                    }
                }

                insertNextProduct();
            }
        })
    },
    getBillDetail: function (req, res) {
        bill_model.getBillDetail(req.body.bill_id, function (err, result) {
            if (err) {
                res.status(500).json({ message: err.message })
            }
            else {
                res.json({ billDetail: result });
            }
        })
    }
}