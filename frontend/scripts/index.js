$(document).ready(function() {
  buildNav("index.html")
  user = Cookies.getJSON('user')
  $(".container").append(
    $("<strong></strong>").append(
        $("<p></p>").text("You are logged in as " + user.role + " " + user.email)))
})
