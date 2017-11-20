$(document).ready(function() {
  buildNav("index.html")
  user = Cookies.getJSON('user')
  if (user) {
    $(".container").append(
      $("<strong></strong>").append(
        $("<p></p>").text("You are logged in as " + user.role + " " + user.email)))
  } else {
    $(".container").append(
      $("<strong></strong>").append(
        $("<p></p>").text("Hi!")))
  }
})
