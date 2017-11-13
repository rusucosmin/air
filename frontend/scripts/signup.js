$(document).ready(function() {
  BASE_PATH = "http://0.0.0.0:3000"
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
    email = $("#inputEmail").val()
    password = $("#inputPassword").val()
    body = {
      user: {
        email,
        password
      }
    }
    $.post(BASE_PATH + "/user", body)
        .done(function(data) {
          $("#alerts").empty()
          $("#alerts").append(
              createAlert("alert alert-success alert-dismissible fade show", true, "You successfully signed up. Please login now.")
          )
        })
        .fail(function(res) {
          $("#alerts").empty()
          body = JSON.parse(res.responseText)
          if (body.errors) {
            errors = body.errors
            for(var i = 0; i < errors.length; ++ i) {
              err = errors[i]
              console.log(i + " " + err)
              $("#alerts").append(
                  createAlert("alert alert-danger alert-dismissible fade show", true, err)
              )
            }
          } else {
              $("#alerts").append(
                  createAlert("alert alert-danger alert-dismissible fade show", true,
                  "There was an error, please check you inputs again.")
              )
          }
          console.log("fail " + body)
        })
  })
})
