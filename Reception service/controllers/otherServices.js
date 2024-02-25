const otherServices_model = require('../model/otherServices');

module.exports = {
    getComputerPrice: function (req, res) {
        otherServices_model.getComputerPrice(req.body.computerId, function (err, result) {
            if (err) {
                res.status(500).json({ message: err.message })
            }
            else {
                console.log(result);
                res.json({ priceList: result[0] });
            }
        })
    },
    sessionList: function (req, res) {
        otherServices_model.sessionList(function (err, result) {
            if (err) {
                res.status(500).json({ message: err.message })
            }
            else {
                console.log(result);
                res.json({ sessionList: result[0] });
            }
        })
    },
    sessionSearchByMember: function (req, res) {
        otherServices_model.sessionSearchByMember(req.body.memberId, function (err, result) {
            if (err) {
                res.status(500).json({ message: err.message })
            }
            else {
                res.json({ sessionList: result[0] });
            }
        })
    },
    sessionSearchByComputer: function (req, res) {
        otherServices_model.sessionSearchByComputer(req.body.computerId, function (err, result) {
            if (err) {
                res.status(500).json({ message: err.message })
            }
            else {
                res.json({ sessionList: result[0] });
            }
        })
    }
}