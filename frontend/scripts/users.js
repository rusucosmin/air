function showUser(user) {
  $("#inputEmail").val(user.email)
  $("#inputRole").val(user.role)
}

var selected = {}

function addToTable(user) {
  var tr =$("<tr></tr>")
      .append(
        $("<td></td>").attr("scope", "col").text(user.id))
      .append(
        $("<td class='email'></td>").text(user.email))
      .append(
        $("<td class='role'></td>").text(user.role))
      .append(
        $("<td></td>").append(
            createButton("btn btn-danger", "Delete", function() {
              if (confirm("You are about to delete user " + user.email)) {
                deleteUser(user, function(success) {
                  console.log("successfullu deleted")
                  $("#" + user.id).remove()
                }, function(err) {
                  console.log("error")
                  $('#alerts').append(
                    createAlert("alert alert-danger", true, "There were some errors.")
                  )
                })
              }
            })))
      .attr("id", user.id)
  tr.click(function() {
    showUser(user)
    selected = user
  })
  $(".table tbody").append(tr)
}

$(document).ready(function() {
  buildNav("users.html")
  getUsers(function(users) {
    console.log("got users")
    console.log(users)
    for(var i = 0; i < users.length; ++ i) {
      addToTable(users[i])
    }
  }, function(err) {
    console.log("error on getting users")
    console.log(err)
  })
  $('#btnCreate').click(function() {
    data = {
      "email": $("#inputEmail").val(),
      "password": $("#inputPassword").val(),
      "role": $("#inputRole").val()
    }
    createUser(data, function(resp) {
      console.log("success")
      console.log(resp)
      addToTable(resp)
    }, function(err) {
      console.log("fail")
      console.log('creating alerts')
      console.log(err)
      $("#alerts").empty()
      if(err.responseJSON && err.responseJSON.errors) {
        var errs = err.responseJSON.errors
        console.log(errs)
        for(var i = 0; i < errs.length; ++ i) {
          $("#alerts").append(
              createAlert("alert alert-danger", true, errs[i]))
        }
      } else {
        $("#alerts").append(
            createAlert("alert alert-danger", true, "There were some errors."))
      }
    })
  })
  $('#btnUpdate').click(function() {
    data = {
      "id": selected.id,
      "email": $("#inputEmail").val(),
      "password": $("#inputPassword").val(),
      "role": $("#inputRole").val()
    }
    updateUser(data, function(resp) {
      console.log("success")
      console.log(resp)
      $("#" + resp.id + " .email").text(resp.email)
      $("#" + resp.id + " .role").text(resp.role)
    }, function(err) {
      console.log("fail")
      console.log('creating alerts')
      console.log(err)
      $("#alerts").empty()
      if(err.responseJSON && err.responseJSON.errors) {
        var errs = err.responseJSON.errors
        console.log(errs)
        for(var i = 0; i < errs.length; ++ i) {
          $("#alerts").append(
              createAlert("alert alert-danger", true, errs[i]))
        }
      } else {
        $("#alerts").append(
            createAlert("alert alert-danger", true, "There were some errors."))
      }
    })
  })
})
