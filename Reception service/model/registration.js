var connect_DB = require('./connect_db');
var jwt = require("jsonwebtoken");
var bcrypt = require("bcrypt");

function checkNoEmpty(res, obj) {
    for (let key in obj) {
        if (obj.hasOwnProperty(key)) {
            if (obj[key] == undefined || obj[key] == null || obj[key] == "") {
                res.status(400).json({ message: "Vui lòng không để trống bất kỳ trường nào!" });
                return false;
            }
        }
    }
    return true;
}

function checkNoDuplicate(res, student_id, email, valid) {
    connect_DB.query("SELECT * FROM members WHERE student_id = ?", [student_id], function (err, result, field) {
        if (err) {
            res.status(500).json({ message: "Hệ thống gặp vấn đề. Vui lòng thử lại sau" });
            valid(false);
        }
        else if (result.length > 0) {
            res.status(400).json({ message: "Thông tin bị trùng. Vui lòng kiểm tra xem bạn đã từng đăng ký với thông tin này chưa" });
            valid(false);
        }
        else {
            connect_DB.query("SELECT * FROM members WHERE email = ?", [email], function (err, result, field) {
                if (err) {
                    res.status(500).json({ message: "Hệ thống gặp vấn đề. Vui lòng thử lại sau" });
                    valid(false);
                }
                else if (result.length > 0) {
                    res.status(400).json({ message: "Thông tin bị trùng. Vui lòng kiểm tra xem bạn đã từng đăng ký với thông tin này chưa" });
                    valid(false);
                }
                else {
                    valid(true);
                }
            })

        }
    })
}

function validate(res, obj, register) {
    if (checkNoEmpty(res, obj)) {
        checkNoDuplicate(res, obj.student_id, obj.email, function (valid) {
            register(valid);
        });
    }
    else
        register(false);
}

function register(res, obj) {
    validate(res, obj, function (valid) {
        if (valid) {
            let currentDate = new Date().toJSON().slice(0, 10);
            let sql = "INSERT INTO members (student_id, student_name, email, password, state, join_date, permission) VALUES (?, ?, ?, ?, ?, ?, ?)"
            connect_DB.query(sql, [
                obj.student_id,
                obj.student_name,
                obj.email,
                obj.password,
                "Đang hoạt động",
                currentDate,
                "Cộng tác viên"
            ], function (err, result) {
                if (err)
                    res.status(500).json({ message: "Hệ thống gặp vấn đề. Vui lòng thử lại sau" });
                else {
                    let member = {
                        student_id: obj.student_id,
                        email: obj.email,
                        state: "Đang hoạt động",
                        permission: "Cộng tác viên"
                    };
                    const token = jwt.sign(member, "RANDOM-TOKEN", { expiresIn: "5m" });
                    res.json({ member: member, token });
                }
            })
        }
    })
}

module.exports = { register }