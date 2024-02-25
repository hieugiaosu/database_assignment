/*
function name: getMenuContent
This function is to get the right menu content in the page
@param: None
@return: string contains the html code of the menu
*/
let getMenuContent = function () {
  return `<div class="row pt-2 my-2 justify-content-center" id="logo_container">
    <svg
    xmlns="http://www.w3.org/2000/svg"
    height="60"
    width="60"
    viewBox="0 0 640 512"
  >
    <!--!Font Awesome Free 6.5.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2023 Fonticons, Inc.-->
    <path
      fill="#105ce0"
      d="M384 96V320H64L64 96H384zM64 32C28.7 32 0 60.7 0 96V320c0 35.3 28.7 64 64 64H181.3l-10.7 32H96c-17.7 0-32 14.3-32 32s14.3 32 32 32H352c17.7 0 32-14.3 32-32s-14.3-32-32-32H277.3l-10.7-32H384c35.3 0 64-28.7 64-64V96c0-35.3-28.7-64-64-64H64zm464 0c-26.5 0-48 21.5-48 48V432c0 26.5 21.5 48 48 48h64c26.5 0 48-21.5 48-48V80c0-26.5-21.5-48-48-48H528zm16 64h32c8.8 0 16 7.2 16 16s-7.2 16-16 16H544c-8.8 0-16-7.2-16-16s7.2-16 16-16zm-16 80c0-8.8 7.2-16 16-16h32c8.8 0 16 7.2 16 16s-7.2 16-16 16H544c-8.8 0-16-7.2-16-16zm32 160a32 32 0 1 1 0 64 32 32 0 1 1 0-64z"
    />
  </svg>
</div>
<div class="row my-2 justify-content-center menu_text">INTERNET CYBER STORE</div>
<div class="row ps-5">
    <div class="row mt-2 mb-2 text-start">
        <a class="menu_text menu_widget text-start btn-sm" id="printer_management_button" href="printer_management.html">
            <img src="image/menu/monitor.png" alt="printer_management" class="pe-2 menu_text">
            Máy tính
        </a>
    </div>
    <div class="row my-2">
        <a class="menu_text menu_widget text-start btn-sm" id="printer_management_button">
            <img src="image/menu/employee.png" alt="accept" class="pe-2">
            Nhân viên
        </a>
    </div>
    <div class="row my-2">
        <a href="history_management.html" class="menu_text menu_widget text-start btn-sm" id="history_button">
            <img src="image/menu/sale-tag.png" alt="history" class="pe-2">
            Khuyến mãi
        </a>
    </div>
    <div class="row my-2">
        <a class="menu_text menu_widget text-start btn-sm" id="revenue_button">
            <img src="image/menu/revenue.png" alt="revenue" class="pe-2">
            Doanh thu
        </a>
    </div>
    <div class="row my-2">
        <a class="menu_text menu_widget text-start btn-sm" id="notification_button">
            <img src="image/menu/bell.png" alt="notification" class="pe-2">
            Thông báo
        </a>
    </div>
    <div class="row my-2">
        <a class="menu_text menu_widget text-start btn-sm" id="response_button">
            <img src="image/menu/communication.png" alt="response" class="pe-2">
            Phản hồi
        </a>
    </div>
</div>
    <div class="row logout_widget mt-auto" onclick="logout()">
        <a class="text-start btn">
            <img src="image/menu/Icon - Logout.svg" alt="response" class="pe-2">
            Đăng xuất
        </a>
    </div>`;
};
/*
function name: getAccount
This function is to get the current account in session
@param: None
@return: string contains the account name
*/
let getAccount = function () {
  return Cookies.get("Ten");
};
/*
function name: getAccountBarContent
This function is to get the top account information bar
@param: None
@return: string contains html code of the top account information bar
*/
let getAccountBarContent = function () {
  return (
    `
    <div class="col-6 ps-5">
    <svg xmlns="http://www.w3.org/2000/svg" width="68" height="65" viewBox="0 0 68 65" fill="none">
        <ellipse cx="33.8593" cy="30.8544" rx="33.2372" ry="30.8544" fill="#EEEEEE"/>
        <path d="M47.0289 46.8986C49.7903 46.8986 52.0954 44.62 51.3563 41.9593C50.5382 39.0144 48.9943 36.3021 46.837 34.0991C43.5126 30.7045 39.0038 28.7974 34.3024 28.7974C29.6011 28.7974 25.0923 30.7045 21.7679 34.0991C19.6105 36.3021 18.0667 39.0144 17.2486 41.9593C16.5095 44.62 18.8145 46.8986 21.5759 46.8986L34.3024 46.8986H47.0289Z" fill="black"/>
        <ellipse cx="34.3022" cy="19.3355" rx="8.86325" ry="8.63924" fill="black"/>
        </svg>
    <span>` +
    getAccount() +
    `</span>
    <a class="btn" href="#">
        <svg xmlns="http://www.w3.org/2000/svg" width="33" height="31" viewBox="0 0 33 31" fill="none">
            <path d="M12.5225 14.7867L15.9583 18.0438C16.4757 18.5343 17.3114 18.5343 17.8288 18.0438L21.2647 14.7867C22.1004 13.9944 21.5035 12.6362 20.3228 12.6362H13.4511C12.2704 12.6362 11.6867 13.9944 12.5225 14.7867Z" fill="#0D0D0D"/>
            </svg>
    </a>
</div>
<div class="col-6 text-end pe-4">
<a class='btn'>
    <svg xmlns="http://www.w3.org/2000/svg" width="43" height="41" viewBox="0 0 43 41" fill="none">
        <path fill-rule="evenodd" clip-rule="evenodd" d="M14.1596 33.7131C15.0758 34.6806 16.2521 35.2121 17.4725 35.2121H17.4743C18.7001 35.2121 19.8816 34.6806 20.7996 33.7114C21.2914 33.1966 22.1298 33.1547 22.6728 33.6192C23.2176 34.0836 23.2618 34.8801 22.7718 35.3949C21.3426 36.8989 19.4624 37.7273 17.4743 37.7273H17.4708C15.488 37.7256 13.6113 36.8973 12.1874 35.3932C11.6974 34.8784 11.7417 34.082 12.2865 33.6192C12.8312 33.153 13.6696 33.195 14.1596 33.7131ZM17.5606 1.67676C25.4229 1.67676 30.7045 7.48173 30.7045 12.9027C30.7045 15.6912 31.4527 16.8733 32.2469 18.1275C33.0322 19.365 33.9219 20.7701 33.9219 23.4261C33.3046 30.212 25.8315 30.7653 17.5606 30.7653C9.28977 30.7653 1.81487 30.212 1.20461 23.5334C1.19933 20.7701 2.08903 19.365 2.87437 18.1275L3.15162 17.6851C3.83425 16.5729 4.41676 15.3631 4.41676 12.9027C4.41676 7.48173 9.69836 1.67676 17.5606 1.67676ZM17.5606 4.19191C11.3787 4.19191 7.06994 8.7829 7.06994 12.9027C7.06994 16.3887 6.04935 18.0001 5.14727 19.422C4.42383 20.5639 3.85251 21.466 3.85251 23.4261C4.1479 26.5885 6.35004 28.2502 17.5606 28.2502C28.7093 28.2502 30.9804 26.5147 31.274 23.3171C31.2687 21.466 30.6974 20.5639 29.974 19.422C29.0719 18.0001 28.0513 16.3887 28.0513 12.9027C28.0513 8.7829 23.7425 4.19191 17.5606 4.19191Z" fill="#0D0D0D"/>
        <path d="M28.6152 12.3662C31.861 12.3662 34.5504 9.86372 34.5504 6.70706C34.5504 3.5504 31.861 1.04797 28.6152 1.04797C25.3694 1.04797 22.6801 3.5504 22.6801 6.70706C22.6801 9.86372 25.3694 12.3662 28.6152 12.3662Z" fill="#F74A4A" stroke="#FEFEFE" stroke-width="1.25758"/>
        </svg>
</a>
</div>
    `
  );
};

function logout() {
  Cookies.remove("accessToken");
  Cookies.remove("Ten");
  Cookies.remove("TenDangNhap");
  Cookies.remove("ID");
  Cookies.remove("ChucVu");
  window.location.href = "login_admin.html";
}
