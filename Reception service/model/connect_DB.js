/*
    ATTENTION: Right now, the database is hard-coded.
    Due to that, I just export the database object.
    When you want to change to a real DB, you should export only the connection variable and no function.
    All APIs to access to the DB should be specified in distict JS files according to the model that each file is representing.
*/
var mysql = require("mysql2")

var connect_DB = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "1234",
    database: "internet_store"
});

connect_DB.connect(function (err) {
    if (err) throw err;
});

module.exports = connect_DB;