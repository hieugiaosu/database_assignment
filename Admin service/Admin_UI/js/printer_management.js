const SIZE = 6;

var printers;
var filteredPrinters;
var currPage = 0;
var totalPapers = 0;
var totalSessions = 0;

/*
This function is to get printer data from the server
*/
async function getPrinterInfo() {
  // implement
  try {
    await $.ajax("http://localhost:3001/printers", {
      beforeSend: (req) => {
        req.setRequestHeader(
          "Authorization",
          `Bearer ${Cookies.get("accessToken")}`
        );
      },
      success: (data) => {
        printers = data;
        filteredPrinters = printers.filter(() => true);
      },
    });
  } catch (error) {
    console.log(error);
  }
}

/*
this play general 
*/
function displayPrinterInfo() {
  $("tbody").html("");
  if (filteredPrinters.length == 0) {
    $(".pagination-row").removeClass("d-flex").addClass("d-none");
    $("tbody").append(
      $(`<tr>
				<td colspan="8" class="text-secondary text-center">
					Không có kết quả
				</td>
			</tr>`)
    );
    return;
  }

  $(".pagination-row").removeClass("d-none").addClass("d-flex");
  while (currPage * SIZE >= filteredPrinters.length) currPage--;
  if (currPage < 0) currPage = 0;

  let begin = currPage * SIZE;
  let end = Math.min((currPage + 1) * SIZE, filteredPrinters.length);

  for (let i = begin; i < end; i++) {
    let printer = filteredPrinters[i];
    let row = `
            <tr id="row${printer.id}" class="${
      printer.TinhTrang == "Disabled" ? "disabled-row" : ""
    }">
				<td scope="col pt-0" class="checkSingle">
					<input
						class="form-check-input"
						type="checkbox"
						value="-1"
						id="printer${printer.hang}"
					/>
				</td>
				<td scope="col pt-0" class="printer_list_data">
					${i + 1}
				</td>
				<td scope="col pt-0" class="printer_list_data">
					${printer["hang"]}
				</td>
				<td scope="col pt-0" class="printer_list_data" id="${printer["id cau hinh"]}">
					${printer["id cau hinh"]}
				</td>
				<td scope="col pt-0" class="printer_list_data">
					${printer["phan loai khu vuc"]}
				</td>
				<td scope="col pt-0" class="printer_list_data text-center">
               ${printer["ngay mua"]}
				</td>
				<td scope="col pt-0 my-0 p-0" class="text-center">
					<a href="printer_detail.html?printerid=${printer.ID}" class="btn p-0 border-0">
						<img src="image/admin_printer/info.png" alt="info" class="infoPrinterBtn" id="info${printer}">
					</a> 
					<button
						class="btn p-0 border-0"
						type="button"
						onclick="deletePrinter('${printer["ID"]}')"
					>
						<img
							src="image/admin_printer/delete.png"
							alt="del"
							class="delPrinterBtn"
							id="del${printer["ID"]}"
						/>
					</button>
				</td>
				
            </tr>
        `;
    $("tbody").append(row);
  }

  $("#pageNumber").val(currPage + 1);
}

async function toggleStatus(id) {
  try {
    await $.ajax(`http://localhost:3001/printers/${id}/status`, {
      method: "PUT",
      beforeSend: (req) => {
        req.setRequestHeader(
          "Authorization",
          `Bearer ${Cookies.get("accessToken")}`
        );
      },
      success: (data) => {
        $(`#row${id}`).toggleClass("disabled-row");
        $(`#status${id}`).toggleClass("enable");
        $(`#status${id}`).toggleClass("disable");
        $(`#status${id}`).text(
          data.TinhTrang == "Working" ? "Hoạt động" : "Vô hiệu hóa"
        );
        showToast("successToast", "Thay đổi trạng thái thành công");
      },
      error: (error) => {
        console.log(error);
      },
    });
  } catch (error) {
    showToast("failToast", "Thay đổi trạng thái thất bại");
    $(`#toggle${id}`).prop("checked", !$(`#toggle${id}`).is(":checked"));
  }
}

async function deletePrinter(id) {
  if ($(`#status${id}`).hasClass("enable")) {
    showToast("failToast", "Máy in đang hoạt động");
    return;
  }
  try {
    $.ajax(`http://localhost:3001/printers/${id}`, {
      method: "DELETE",
      beforeSend: (req) => {
        req.setRequestHeader(
          "Authorization",
          `Bearer ${Cookies.get("accessToken")}`
        );
      },
      success: async (msg) => {
        showToast("successToast", "Máy in đã được xóa");

        // Remove printer from global list
        printers = printers.filter((element) => element.ID !== id);
        filteredPrinters = printers.filter(() => true);

        // Update number of printers
        $(`#printer_number .quantity`).text(printers.length);

        // Display list of printers again
        displayPrinterInfo();
      },
    });
  } catch (error) {
    showToast("failToast", "Xóa máy in không thành công");
  }
}

async function getGeneralInfo() {
  try {
    await $.ajax("http://localhost:3001/printers/total", {
      beforeSend: (req) => {
        req.setRequestHeader(
          "Authorization",
          `Bearer ${Cookies.get("accessToken")}`
        );
      },
      success: (data) => {
        total = data;
      },
    });
    await $.ajax("http://localhost:3001/printers/totalpage", {
      beforeSend: (req) => {
        req.setRequestHeader(
          "Authorization",
          `Bearer ${Cookies.get("accessToken")}`
        );
      },
      success: (data) => {
        totalPapers = data;
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
    showToast("failToast", `Error while fetching general info`);
  }
}

function displayGeneralInfo() {
  $(`#printer_number .quantity`).text(total);
  $(`#paper_number .quantity`).text(totalPapers);
  $(`#print_session_number .quantity`).text(totalSessions);
}

function createPrinter(e) {
  e.preventDefault();

  let data = {
    ID: printers[printers.length - 1].ID + 1,
    hang: escapeHtml(e.target["firm"].value),
    "id cau hinh": escapeHtml($("#cauhinh>input").val()),
    "phan loai khu vuc": escapeHtml($("#location>input").val()),
    "ngay mua": escapeHtml($("#buydate>input").val()),
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
  } else {
    $.ajax("http://localhost:3001/printers/", {
      method: "POST",
      beforeSend: function (req) {
        req.setRequestHeader(
          "Authorization",
          "Bearer: " + Cookies.get("accessToken")
        );
      },
      contentType: "application/json",
      data: JSON.stringify(data),
      success: async function (msg) {
        console.log(msg);
        if (msg.message == "Computer added successfully") {
          showToast("successToast", "Thêm máy in thành công");
          $("tbody").html("");
          $(".cancel-form").click();
          await getPrinterInfo();
          await getGeneralInfo();
          displayPrinterInfo();
          displayGeneralInfo();
        } else {
          console.log(fail);
          showToast("failToast", "Thêm máy in thấy bại");
        }
      },
      error: function () {
        showToast("failToast", "Thêm máy in thất bại");
      },
    });
  }
}

$(document).ready(async function () {
  $("#menu").html(getMenuContent());
  await getPrinterInfo();
  await getGeneralInfo();

  displayPrinterInfo();
  displayGeneralInfo();

  $("#account_bar").html(getAccountBarContent());

  $("#printer_management_button").css("background-color", "#C8C2F2");

  $("#logo").click(function () {
    window.location.href = "home_admin.html";
  });

  $("#checkAll").click(function () {
    $(".checkSingle>input").not(this).prop("checked", this.checked);
  });

  $(".checkSingle>input").click(function () {
    if (
      $(".checkSingle>input:checked").length == $(".checkSingle>input").length
    ) {
      $("#checkAll").prop("checked", true);
    } else {
      $("#checkAll").prop("checked", false);
    }
  });

  $(".btn-check").click(function () {
    $(".btn-check").not(this).prop("checked", !this.checked);
  });

  $("#upload-image>button").click(function () {});

  $("form").submit(createPrinter);

  $("#nextPage").click(function () {
    currPage++;
    displayPrinterInfo();
  });

  $("#previousPage").click(function () {
    currPage--;
    displayPrinterInfo();
  });

  $("#gotoPage").click(function () {
    currPage = $("#pageNumber").val();
    displayPrinterInfo();
  });

  $("#pageNumber").keydown(function (e) {
    if (e.which == 13) {
      $("#gotoPage").click();
    }
  });

  $("#search_bar").on("input", async function () {
    currPage = 0;
    filterPrinters();
    displayPrinterInfo();
  });
});

async function filterPrinters() {
  let val = $(`#search_bar`).val().toLowerCase();
  filteredPrinters = printers.filter((element) => {
    return (
      element["phan loai khu vuc"].toLowerCase().includes(val) ||
      element.hang.toLowerCase().includes(val)
    );
  });
}
