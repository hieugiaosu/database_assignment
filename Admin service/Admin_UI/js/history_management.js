const SIZE = 6;

var userHistory;
var currPage = 0;

async function getPrintingInfo() {
	try {
		await $.ajax({
			url: "http://localhost:3001/history/",
			method: "get",
			beforeSend: function (req) {
				req.setRequestHeader(
					"Authorization",
					"Bearer: " + Cookies.get("accessToken")
				);
			},
			success: (result) => {
				console.log(result);
				userHistory = result;
			},
			error: (err) => {},
		});
	} catch (err) {
		console.log(err);
	}
}

async function displayHistory() {
	$("tbody").html("");
	if (userHistory.length == 0) return;

	while (currPage * SIZE >= userHistory.length) currPage--;
	if (currPage < 0) currPage = 0;

	let begin = currPage * SIZE;
	let end = Math.min((currPage + 1) * SIZE, userHistory.length);

	for (let i = begin; i < end; i++) {
		let data = userHistory[i];
		let row = $('<tr class="my-2"></tr>');
		row.append(
			$(`<td class="Montserrat">
				${data["Người dùng"]}
				<br>
				<footer class="Montserrat-500 text-secondary">
					${data["ID"]}
				</footer>
            </td>`)
		);
		row.append($(`<td>${data["Số lượt in"]}</td>`));
		row.append($(`<td>${data["Số lượng giấy đã in"]}</td>`));
		row.append(
			$(`<td>
				<a
					href="./user_history.html?ID=${data["ID"]}&name=${data["Người dùng"]}"
					class="bg-theme-color btn"
				>
					Xem lịch sử
                </a>
			</td>`)
		);
		$("tbody").append(row);
	}
	$("#pageNumber").val(currPage + 1);
}

$(document).ready(async function () {
	$("#menu").html(getMenuContent());
	$("#account_bar").html(getAccountBarContent());
	$("#history_button").css("background-color", "#C8C2F2");
	$("#logo").click(function () {
		window.location.href = "home_admin.html";
	});

	await getPrintingInfo();
	displayHistory();
	console.log(userHistory);

	$("#nextPage").click(async function () {
		currPage++;
		displayHistory();
	});

	$("#previousPage").click(async function () {
		currPage--;
		displayHistory();
	});

	$("#gotoPage").click(async function () {
		currPage = $("#pageNumber").val();
		displayHistory();
	});

	$("#pageNumber").keydown(function (e) {
		if (e.which == 13 && !$(".printer-history").is(":hidden")) {
			$("#gotoPage").click();
		}
	});
});
