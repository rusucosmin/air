function showJogg(jogg) {
  $("#inputDate").val(jogg.date)
  $("#inputDistance").val(jogg.distance)
  $("#inputDuration").val(jogg.duration)
}

var selected = {}

function addToTable(jogg) {
  var tr =$("<tr></tr>")
      .append(
        $("<td></td>").attr("scope", "col").text(jogg.id))
      .append(
        $("<td class='date'></td>").text(jogg.date))
      .append(
        $("<td class='distance'></td>").text(jogg.distance + " km"))
      .append(
        $("<td class='duration'></td>").text(jogg.duration + " min"))
      .append(
        $("<td class='speed'></td>").text(parseFloat(jogg.distance / jogg.duration).toFixed(2) + "km / min"))
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
  buildNav("dashboard.html")
  getJoggingLogs(function(resp) {
    console.log("got jogging logs")
    console.log(resp)
    for(var i = 0; i < resp.length; ++ i) {
      addToTable(resp[i])
    }
  }, function(err) {
    console.log("error on getting jogging logs")
    console.log(err)
    $('#alerts').append(
        createAlert('alert alert-danger', true, "There were some errors."))
  });
  $('#btnCreate').click(function() {
    data = {
      "date": $("#inputDate").val(),
      "distance": $("#inputDistance").val(),
      "duration": $("#inputDuration").val(),
      "user_id": Cookies.getJSON('user').id
    }
    console.log('create button clicked')
    console.log(data)
    createJoggingLog(data, function(jogg) {
      console.log("created")
      console.log(jogg)
      addToTable(jogg)
      selected = jogg
    }, function(err) {
      console.log('error on create')
      console.log(err)
      $('#alerts').append(
          createAlert('alert alert-danger', true, "There were some errors."))
    })
  })
  $('#btnUpdate').click(function() {
    data = {
      "id": selected.id,
      "date": $("#inputDate").val(),
      "distance": $("#inputDistance").val(),
      "duration": $("#inputDuration").val(),
      "user_id": Cookies.getJSON('user').id
    }
    updateJoggingLog(data, function(jogg) {
      console.log("updated jogg")
      console.log(jogg)
      $("#" + jogg.id + " .date").text(jogg.date)
      $("#" + jogg.id + " .duration").text(jogg.duration + " min")
      $("#" + jogg.id + " .distance").text(jogg.distance + " km")
      $("#" + jogg.id + " .speed").text(parseFloat(jogg.distance / jogg.duration).toFixed(2) + " km / min")
    }, function(err) {
      console.log('Error')
      console.log(err)
      console.log(
          createAlert('alert alert-danger', true, "There were some errors."))
    })
  })
})
