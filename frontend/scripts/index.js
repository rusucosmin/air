$(document).ready(function() {
  buildNav("index.html")
  user = Cookies.getJSON('user')
  if (user) {
    $("#welcome").append(
      $("<center></center>").append(
        $("<h1></h1>")
          .append("Hi, " + (user.email || ""))
          .append($("<br />Just Jogged? "))
          .append($("<a></a>").attr("href", "/dashboard.html")
              .text("Log"))
          .append(" your activity now!")))
  } else {
    $("#welcome").append(
      $("<center></center>").append(
        $("<h1></h1>")
          .append("Hi, ")
          .append($("<a></a>").attr("href", "/login.html")
              .text("login"))
          .append(" to start using Joggingly!")))
  }
})
