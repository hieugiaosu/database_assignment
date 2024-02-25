const connect_DB = require('./connect_DB');

function getComputerPrice(computer_id, controller) {
    connect_DB.query("CALL GetMayTinhInfo(?)", [computer_id], function (err, result) {
        controller(err, result);
    })
}

function sessionList(controller) {
    connect_DB.query("CALL GetActiveSessions()", function (err, result) {
        controller(err, result);
    })
}

function sessionSearchByMember(member_id, controller) {
    connect_DB.query("CALL GetActiveSessionsByTaiKhoanHV(?)", [member_id], function (err, result) {
        controller(err, result);
    })
}

function sessionSearchByComputer(computer_id, controller) {
    connect_DB.query("CALL GetActiveSessionsByIdMayTinh(?)", [computer_id], function (err, result) {
        controller(err, result);
    })
}

module.exports = {
    getComputerPrice,
    sessionList,
    sessionSearchByMember,
    sessionSearchByComputer
}