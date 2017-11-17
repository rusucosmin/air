$(document).ready(function() {
  buildNav("signout.html")
  $("#signoutBtn").click(function() {
    console.log("signed out button clicked")
    // delete all the cookies (including the jwt)
    for (var cookie in Cookies.get()) {
      console.log("removing cookie " + cookie)
      Cookies.remove(cookie)
    }
    $("#alerts").empty()
    $("#alerts").append(
      createAlert("alert alert-success", false, "You successfully logged out.")
    )
    setTimeout(function() {
      $.redirect("./login.html", {}, "GET")
    }, 250)
  })
})
