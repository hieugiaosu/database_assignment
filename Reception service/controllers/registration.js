var bcrypt = require("bcrypt");
var registration_model = require("../model/registration")

module.exports = {
    register: function (req, res) {
        if (req.body.password) {
            bcrypt.hash(req.body.password, 10)
                .then((hashedPassword) => {
                    let member = {
                        student_id: req.body.student_id,
                        student_name: req.body.student_name,
                        email: req.body.email,
                        password: hashedPassword
                    };
                    registration_model.register(res, member);
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