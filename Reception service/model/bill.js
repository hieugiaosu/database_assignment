const connect_DB = require('./connect_DB');

function getProduct(product_name, controller) {
    connect_DB.query("CALL GetProductInfo(?)", [product_name], function (err, result) {
        controller(err, result);
    })
}

function createBill(billInfo, controller) {
    connect_DB.query("CALL InsertHoaDon(?, ?)", 
    [
        billInfo.memberId,
        billInfo.employeeId
    ], function(err, result) {
        controller(err, result);
    })
}

function insertProductToBill(bill_id, productInfo, controller) {
    connect_DB.query("CALL addProductToBill(?, ?, ?)", 
    [
        productInfo.productId,
        productInfo.quantity,
        bill_id
    ], function(err, result) {
        controller(err, result);
    })
}

function applyDiscountToBill(bill_id, controller) {
    connect_DB.query("CALL applyDiscountToBill(?)", [bill_id], function(err, result) {
        controller(err, result);
    })
}

function getBillDetail(bill_id, controller) {
    connect_DB.query("CALL GetHoaDonByMaHoaDon(?)", [bill_id], function(err, result) {
        if (err) {
            controller(err, null);
        }
        else {
            console.log(result[0][0]);
            console.log(result[0][0].totalPrice);
            let billDetail = {
                id: result[0][0].id,
                date: result[0][0].date,
                totalPrice: result[0][0].totalPrice,
                memberId: result[0][0].memberId,
                employeeId: result[0][0].employeeId,
                productList: []
            };
            connect_DB.query("CALL GetChuaByMaHoaDon(?)", [bill_id], function(err, result) {
                if (err) {
                    controller(err, null);
                }
                else {
                    console.log(result[0]);
                    billDetail.productList = result[0];
                    controller(null, billDetail);
                }
            })
        }
    })
}

module.exports = {
    getProduct,
    createBill,
    insertProductToBill,
    applyDiscountToBill,
    getBillDetail
}
