const connect_DB = require("./connect_DB")

function memberList(controller) {
    connect_DB.query("CALL SelectHoiVienInfo()", function (err, result) {
        controller(err, result);
    })
}

function memberAdd(member, controller) {
    console.log(member);
    connect_DB.query("CALL AddHoiVien(?, ?, ?, ?, ?)",
        [
            member.account,
            member.password,
            member.name,
            member.phoneNumber,
            member.email
        ], function(err, result) {
            controller(err, result);
        })
}

module.exports = {
    memberList,
    memberAdd
}