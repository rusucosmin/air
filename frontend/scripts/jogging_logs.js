function showJogg(jogg) {
  $("#inputDate").val(jogg.date)
  $("#inputDuration").val(jogg.duration)
  $("#inputDistance").val(jogg.distance)
}

var selected = {}

function addToTable(jogg) {
  var tr =$("<tr></tr>")
      .append(
        $("<td></td>").attr("scope", "col").text(jogg.id))
      .append(
        $("<td class='user_id'></td>").text(jogg.user.id))
      .append(
        $("<td class='user_email'></td>").text(jogg.user.email))
      .append(
        $("<td class='user_role'></td>").text(jogg.user.role))
      .append(
        $("<td class='date'></td>").text(jogg.date))
      .append(
        $("<td class='distance'></td>").text(jogg.distance + " km"))
      .append(
        $("<td class='duration'></td>").text(jogg.duration + " min"))
      .append(
        $("<td></td>").append(
            createButton("btn btn-danger", "Delete", function() {
              if (confirm("You are about to delete jogging log with id=" + jogg.id)) {
                deleteJoggingLog(jogg, function(success) {
                  console.log("successfully deleted")
                  $("#" + jogg.id).remove()
                  $('#alerts').append(
                    createAlert("alert alert-success", true, "Successfuly deleted jogging log.")
                  )
                }, function(err) {
                  console.log("error")
                  $('#alerts').append(
                    createAlert("alert alert-danger", true, "There were some errors.")
                  )
                })
              }
            })))
    .attr("id", jogg.id)
  tr.click(function() {
    showJogg(jogg)
    selected = jogg
  })
  $(".table tbody").append(tr)
}

$(document).ready(function() {
  buildNav("jogging_logs.html")
  getAdminJoggingLogs(function(resp) {
    console.log('got admin jogging logs')
    console.log(resp)
    for(var i = 0; i < resp.length; ++ i) {
      addToTable(resp[i])
    }
  }, function(err) {
    console.log('error get admin jogging logs')
    console.log(err)
  })
  $("#btnUpdate").click(function() {
    data = {
      "id": selected.id,
      "date": $("#inputDate").val(),
      "distance": $("#inputDistance").val(),
      "duration": $("#inputDuration").val()
    }
    updateJoggingLog(data, function(jogg) {
      console.log("updated jogg")
      console.log(jogg)
      $("#" + jogg.id + " .date").text(jogg.date)
      $("#" + jogg.id + " .duration").text(jogg.duration + " min")
      $("#" + jogg.id + " .distance").text(jogg.distance + " km")
      $("#alerts").append(
        createAlert("alert alert-success", true, "Successfully updated jogg.")
      )
    }, function(jogg) {
      $("#alerts").append(
        createAlert("alert alert-danger", true, "Error on updating jogg.")
      )
    })
  })
})
