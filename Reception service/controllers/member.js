const member_model = require('../model/member');
var bcrypt = require("bcrypt");

module.exports = {
    memberList: function (req, res) {
        member_model.memberList(function (err, result) {
            if (err) {
                res.status(500).json({ message: err.message })
            }
            else {
                res.json({ memberList: result[0] });
            }
        })
    },
    memberAdd: function (req, res) {
        if (req.body.password) {
            bcrypt.hash(req.body.password, 10)
                .then((hashedPassword) => {
                    let member = {
                        account: req.body.account,
                        password: hashedPassword,
                        name: req.body.name,
                        email: req.body.email,
                        phoneNumber: req.body.phoneNumber
                    }
                    member_model.memberAdd(member, function (err, result) {
                        if (err) {
                            res.status(500).json({ message: err.message })
                        }
                        else {
                            res.json({ message: "Thêm hội viên mới thành công!" })
                        }
                    })
                })
                .catch((error) => {
                    res.status(500).json({ message: "Hệ thống gặp vấn đề. Vui lòng thử lại sau" });
                })
        }
        else {
            res.status(400).json({ message: "Vui lòng không để trống trường nào!" });
        }

    }

}