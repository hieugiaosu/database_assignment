const SIZE = 6;

var userHistory = [];
var currPage = 0;
var params;

function dateProcess(dateString) {
	let date = new Date(dateString);
	let dd = date.getDate();
	let mm = date.getMonth() + 1;
	let yyyy = date.getFullYear();
	if (dd < 10) dd = "0" + dd;
	if (mm < 10) mm = "0" + mm;
	return dd + "/" + mm + "/" + yyyy;
}

function timeProcess(dateString) {
	let date = new Date(dateString);
	let hh = date.getHours();
	let mm = date.getMinutes();
	let ss = date.getSeconds();
	if (hh < 10) hh = "0" + hh;
	if (mm < 10) mm = "0" + mm;
	if (ss < 10) ss = "0" + ss;
	return hh + ":" + mm + ":" + ss;
}

async function getUserHistory() {
	try {
		await $.ajax({
			url: `http://localhost:3001/history/${params.get("ID")}`,
			method: "GET",
			beforeSend: function (req) {
				req.setRequestHeader(
					"Authorization",
					"Bearer: " + Cookies.get("accessToken")
				);
			},
			success: (result) => {
				userHistory = result;

				userHistory.sort((first, second) => {
					if (first["Thời gian In"] > second["Thời gian In"])
						return -1;
					else if (first["Thời gian In"] < second["Thời gian In"])
						return 1;
					return 0;
				});
			},
			error: (err) => {
				console.log(err);
			},
		});
	} catch (err) {
		await requestToken();
		getUserHistory();
	}
}

function displayHistory() {
	$(".totalPrint").text(userHistory.length);

	if (userHistory.length == 0) return;

	$(".start-day").html(
		`(tính từ ${dateProcess(
			userHistory[userHistory.length - 1]["Thời gian In"]
		)})`
	);
	$("tbody").html("");

	while (currPage * SIZE >= userHistory.length) currPage--;
	if (currPage < 0) currPage = 0;

	let begin = currPage * SIZE;
	let end = Math.min((currPage + 1) * SIZE, userHistory.length);

	for (let i = begin; i < end; i++) {
		let data = userHistory[i];
		let row = $('<tr class="my-2"></tr>');
		row.append($(`<td>${data["Máy in"]}<br></td>`));
		row.append(
			$(`
            <td>
				${dateProcess(data["Thời gian In"])}
				<br>
				<footer class="Montserrat-500 text-secondary">
					${timeProcess(data["Thời gian In"])}
				</footer>
            </td>
        `)
		);
		row.append(
			$(`
            <td>
				${data["Số tờ"]}
				<br>
				<footer class="Montserrat-500 text-secondary">
					${data["Loại giấy"]}
				</footer>
            </td>
        `)
		);
		row.append(
			$(`
			<td>
				${data["Tên tài liệu"]}
			</td>
			`)
		);
		row.append(
			$(`
			<td class="d-flex justify-content-center align-items-center">
				<span class='text-center ${
					{
						"Hoàn Thành": "successStatus",
						"Đang In": "inprogressStatus",
						"Chờ Xử Lý": "waitingStatus",
						"Thất bại": "failingStatus",
					}[data["Tình trạng"]]
				} w-100 rounded'>
					${data["Tình trạng"]}
				<span>
			</td>
			`)
		);
		$("tbody").append(row);
	}
	$("#pageNumber").val(currPage + 1);
}

$(document).ready(async function () {
	if (!Cookies.get("accessToken")) {
		window.location.href = "user_login.html";
	}
	params = new URLSearchParams(window.location.search);
	await getUserHistory();

	$("#user-id").html(params.get("ID"));
	$("#user-name").html(params.get("name"));

	if (userHistory.length == 0) {
		$(".pagination-row").prop("hidden", true);
		$("#export").prop("hidden", true);
	} else {
		$(".pagination-row").prop("hidden", false);
		$("#export").prop("hidden", false);
		$(".start-day").html(
			`(tính từ ${dateProcess(
				userHistory[userHistory.length - 1]["Thời gian In"]
			)})`
		);
	}
	displayHistory();

	$("#nextPage").click(function () {
		currPage++;
		displayHistory();
	});

	$("#previousPage").click(function () {
		currPage--;
		displayHistory();
	});

	$("#gotoPage").click(function () {
		currPage = $("#pageNumber").val();
		displayHistory();
	});

	$("#pageNumber").keydown(function (e) {
		if (e.which == 13 && !$(".printer-history").is(":hidden")) {
			$("#gotoPage").click();
		}
	});

	$(".totalPrint").html(history.length);
	displayHistory();

	$("#back").click(function () {
		window.location.href = "./history_management.html";
	});
});
