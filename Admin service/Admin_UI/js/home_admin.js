$(document).ready(function() {
    $('#menu').html(getMenuContent())
    $('#account_bar').html(getAccountBarContent())
    $('#logo').click(function(){
        window.location.href = "home_admin.html"
    })
});
  