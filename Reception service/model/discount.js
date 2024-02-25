const connect_DB = require('./connect_DB');

function discountList(controller) {
    connect_DB.query("CALL SelectKhuyenMaiInfo()", function (err, result) {
        controller(err, result);
    })
}

function discountAdd(discount, controller) {
    connect_DB.query("CALL InsertKhuyenMai(?, ?, ?, ?, ?, ?, ?, ?)",
        [
            discount.discountID,
            discount.discountName,
            discount.description,
            discount.startDate,
            discount.endDate,
            discount.category,
            discount.condition,
            discount.discountValue
        ], function (err, result) {
            controller(err, result);
        })
}

function discountForProduct(product_id, controller) {
    connect_DB.query("CALL GetKhuyenMaiInfoForSanPham(?)", [product_id], function (err, result) {
        controller(err, result);
    })
}

module.exports = {
    discountList,
    discountAdd,
    discountForProduct
}