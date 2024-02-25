const SIZE = 6;
var currPage = 0;
var printerID;
var printer = {};
var printerHistory = [];
var totalSessions = 0;

function resetinput() {
  $(".changable>input").css("color", "black");
  $("#location1>input").val(printer["phan loai khu vuc"]);
  $("#firm1>input").val(printer.hang);
  $("#buydate1>input").val(printer["ngay mua"]);
  $("#cauhinh1>input").val(printer["id cau hinh"]);
}

function updateInfo() {
  $("#printer_id").html(printer.ID);
  $("#firm1>span").html(printer.hang);
  $("#location1>span").html(printer["phan loai khu vuc"]);

  $("#buydate1>span").html(printer["ngay mua"]);
  $("#cauhinh1>span").html(printer["id cau hinh"]);
}

async function getPrinterHistory() {
  try {
    await $.ajax(`http://localhost:3001/history/printer/${printerID}`, {
      method: "GET",
      beforeSend: (req) => {
        req.setRequestHeader(
          "Authorization",
          `Bearer ${Cookies.get("accessToken")}`
        );
      },
      success: (data) => {
        printerHistory = data;
      },
    });
  } catch (error) {}
}

function showPrinterHistory() {
  $("tbody").html("");

  if (printerHistory.length == 0) {
    let row = $('<tr class="my-2"></tr>');
    row.append(
      $(
        `<td colspan="5" class="text-center text-secondary">Không có kết quả</td>`
      )
    );
    $("tbody").append(row);
    $("div.pagination-row").removeClass("d-flex");
    $("div.pagination-row").addClass("d-none");
    return;
  }

  while (currPage * SIZE >= printerHistory.length) currPage--;
  if (currPage < 0) currPage = 0;

  let begin = currPage * SIZE;
  let end = Math.min((currPage + 1) * SIZE, printerHistory.length);

  for (var i = begin; i < end; i++) {
    let data = printerHistory[i];
    let row = $('<tr class="my-2"></tr>');
    row.append(
      $(`
            <td>${data.NguoiDung}<br>
            <footer class="Montserrat-500 text-secondary">${data.IDNguoiDung}</footer>
            </td>`)
    );
    row.append(
      $(`
            <td>${dateProcess(data.ThoiGian)}<br>
            <footer class="Montserrat-500 text-secondary">${timeProcess(
              data.ThoiGian
            )}</footer>
            </td>
        `)
    );
    row.append(
      $(`
            <td>${data.SoTrang}<br>
            <footer class="Montserrat-500 text-secondary">${data.LoaiGiay}</footer>
            </td>
        `)
    );
    row.append($(`<td>${data.TenTaiLieu}</td>`));
    row.append(
      $(`
        <td class="d-flex justify-content-center align-items-center">
            <span class='text-center ${
              {
                "Hoàn Thành": "successStatus",
                "Đang In": "inprogressStatus",
                "Chờ Xử Lý": "waitingStatus",
                "Thất bại": "failingStatus",
              }[data.TinhTrang]
            } w-100 rounded'>${data.TinhTrang}<span>
        </td>`)
    );
    $("tbody").append(row);
  }
  $("#pageNumber").val(currPage + 1);
}

async function getPrinterInfo() {
  try {
    await $.ajax(`http://localhost:3001/printers/${printerID}`, {
      method: "GET",
      beforeSend: (req) => {
        req.setRequestHeader(
          "Authorization",
          `Bearer ${Cookies.get("accessToken")}`
        );
      },
      success: (data) => {
        printer = data;
      },
    });
    await $.ajax("http://localhost:3001/printers/totalprints", {
      beforeSend: (req) => {
        req.setRequestHeader(
          "Authorization",
          `Bearer ${Cookies.get("accessToken")}`
        );
      },
      success: (data) => {
        totalSessions = data;
      },
    });
  } catch (error) {
    console.log(error);
  }
}

async function updatePrinterInfo() {
  let data = {
    ID: printerID,
    hang: escapeHtml($("#firm1>input").val()),
    "id cau hinh": escapeHtml($("#cauhinh1>input").val()),
    "phan loai khu vuc": escapeHtml($("#location1>input").val()),
    "ngay mua": escapeHtml($("#buydate1>input").val()),
  };
  console.log(data);
  //   for (let i = 0; i < data.length; i++) {
  //     let key = ["hang", "ngay mua", "phan loai khu vuc", "id cau hinh"];
  //     data[key[i]] = preprocessedInput[i];
  //   }
  let valid = validateInput(
    data.ID,
    data.hang,
    data["id cau hinh"],
    data["phan loai khu vuc"],
    data["ngay mua"],
    totalSessions
  );
  console.log(valid);

  if (!valid) {
    showToast("failToast", "Thông tin không hợp lệ");
    return;
  }

  try {
    let id = $("#printer_id").text();
    console.log(id);
    const resAPI = await $.ajax(`http://localhost:3001/printers/${id}`, {
      method: "PUT",
      contentType: "application/json",
      beforeSend: (req) => {
        req.setRequestHeader(
          "Authorization",
          `Bearer ${Cookies.get("accessToken")}`
        );
      },
      data: JSON.stringify(data),
    });
    await $.ajax(`http://localhost:3001/printers/${id}`, {
      beforeSend: (req) => {
        req.setRequestHeader(
          "Authorization",
          `Bearer ${Cookies.get("accessToken")}`
        );
      },
      success: (data) => {
        printer = data;
        console.log(printer);
      },
    });

    $("#editmode").click();
    updateInfo();
    $(".changable>input").css("color", "black");
    showToast("successToast", "Máy in đã được cập nhật thông tin");
  } catch (err) {
    console.log(err);
    showToast("failToast", "Có lỗi xảy ra");
  }
}

$(document).ready(async function () {
  printerID = new URLSearchParams(window.location.search).get("printerid");
  await getPrinterInfo();
  updateInfo();
  resetinput();

  //await getPrinterHistory();
  $(".totalPrint").html(printerHistory.length);
  if (printerHistory.length)
    $(".start-day").html(
      `(tính từ ${dateProcess(
        printerHistory[printerHistory.length - 1].ThoiGian
      )})`
    );

  $("#reset").click(resetinput);

  $("#submit").click(updatePrinterInfo);

  $(".back").click(function () {
    window.location.href = "printer_management.html";
  });

  $("#editmode").click(function () {
    $(".changable>span").prop("hidden", this.checked);
    $(".change-detail").prop("hidden", !this.checked);
    $("#submit").prop("disabled", !this.checked);
    $("#reset").prop("disabled", !this.checked);
    $(".btn-check").click(function () {
      $(".btn-check").not(this).prop("checked", !this.checked);
    });
  });

  $(".form-control").change(async function () {
    $(this).css("color", "red");
  });

  $("#showPrinterHistory").click(async function () {
    $(".printer-detail").prop("hidden", true);
    $(".printer-history").removeClass("d-none").addClass("d-flex");
    try {
      currPage = 0;
      showPrinterHistory();

      $(".pagination-row").prop("hidden", false);
    } catch (err) {
      $(".pagination-row").prop("hidden", true);
      $("#export").prop("hidden", true);
    }
  });

  $("#showPrinterDetail").click(function () {
    $(".printer-history").removeClass("d-flex").addClass("d-none");
    $(".printer-detail").prop("hidden", false);
    updateInfo();
  });

  $("#nextPage").click(function () {
    currPage++;
    showPrinterHistory();
  });

  $("#previousPage").click(function () {
    currPage--;
    showPrinterHistory();
  });

  $("#gotoPage").click(async function () {
    currPage = $("#pageNumber").val();
    showPrinterHistory();
  });

  $("#pageNumber").keydown(function (e) {
    if (e.which == 13 && !$(".printer-history").is(":hidden")) {
      $("#gotoPage").click();
    }
  });
});
