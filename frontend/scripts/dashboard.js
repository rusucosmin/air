function showJogg(jogg) {
  $("#inputDate").val(jogg.date)
  $("#inputDistance").val(jogg.distance)
  $("#inputDuration").val(jogg.duration)
}

var selected = {}

function tryFilter(start_date, end_date) {
  data = {}
  if (start_date) {
    data = Object.assign(data, {start_date})
  }
  if (end_date) {
    data = Object.assign(data, {$end_date})
  }
  console.log("try filter with data:")
  console.log(data)
  filterJoggingLogs(data, function(resp) {
    console.log("success")
    console.log(resp)
    $("#tbl_jogs tbody").empty()
    for(var i = 0; i < resp.length; ++ i) {
      addToTable(resp[i])
    }
  }, function(err) {
    console.log("error on getting filtered")
    console.log(err)
  })

}

function showStats(params) {
  getStatistics(params, function(resp) {
    console.log('statistics::request::success')
    console.log(resp)
    $("#tbl").remove()
    var table = $("<table></table>")
        .addClass('table table-hover')
        .attr('id', 'tbl')
        .append(
          $("<thead></thead>")
            .append(
              $("<tr></tr>")
                .append(
                  $("<th></th>")
                    .attr("scope", "col")
                    .text("Start date"))
                .append(
                  $("<th></th>")
                    .attr("scope", "col")
                    .text("End date"))
                .append(
                  $("<th></th>")
                    .attr("scope", "col")
                    .text("Total distance"))
                .append(
                  $("<th></th>")
                    .attr("scope", "col")
                    .text("Total duration"))
                .append(
                  $("<th></th>")
                    .attr("scope", "col")
                    .text("Jogging sessions"))
                .append(
                  $("<th></th>")
                    .attr("scope", "col")
                    .text("Average distance"))
                .append(
                  $("<th></th>")
                    .attr("scope", "col")
                    .text("Average speed"))))
    table.append(
      $("<tbody></tbody>")
        .append($("<td></td>").text(resp.first_date))
        .append($("<td></td>").text(resp.last_date))
        .append($("<td></td>").text(resp.total_distance))
        .append($("<td></td>").text(resp.total_duration))
        .append($("<td></td>").text(resp.jogs_number))
        .append($("<td></td>").text(resp.total_distance / resp.jogs_number || "-"))
        .append($("<td></td>").text(resp.total_distance / resp.total_duration || "-"))
    )
    $("#statistics").append(table)
  }, function(err) {
    console.log('statistics::request::error')
    console.log(err)
  })
}

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
  $("#tbl_jogs tbody").append(tr)
}

$(document).ready(function() {
  buildNav("dashboard.html")
  showStats({})
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
  $('#btnFilter').click(function() {
    console.log("filter")
    tryFilter($("#inputStartDate").val(), $("#inputEndDate").val())
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
  $('#inputWeek').change(function() {
    console.log('Selected ' + $("#inputWeek").val())
    showStats({'date': $('#inputWeek').val()})
  })
})
