$(document).ready(function() {
  buildNav("login.html")
  function createAlert(classes, dissmissable, text) {
    d = $("<div>", {"class": classes, "role": "alert"})
    d.html(text)
    if(dissmissable) {
      d.append($("<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
          + "<span aria-hidden='true'>&times;</span>"
          + "</button>"))
    }
    return d
  }
  $("#btn").click(function() {
    //TODO: validate
    //TODO: fix lower case on backend
    email = $("#inputEmail").val()
    password = $("#inputPassword").val()
    body = {
      auth: {
        email,
        password
      }
    }
    $.post(BASE_PATH + "/user_token", body)
        .done(function(data) {
          $("#alerts").empty()
          $("#alerts").append(
              createAlert("alert alert-success alert-dismissible fade show", true, "You successfully logged in. ")
          )
          console.log("got jwt: " + data.jwt)
          Cookies.set('jwt', data.jwt, { expires: 7 })
          setTimeout(function() {
            $.redirect("./index.html", {}, "GET")
          }, 250)
        })
        .fail(function(res) {
          $("#alerts").empty()
          $("#alerts").append(
              createAlert("alert alert-danger alert-dismissible fade show", true,
              "There was an error, please check you credentials.")
          )
          console.log("fail " + JSON.stringify(body))
        })
  })
})
