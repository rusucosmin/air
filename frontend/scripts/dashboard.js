function showJogg(jogg) {
  $("#jogg").show("medium")
  $("#inputDate").val(jogg.date)
  $("#inputDistance").val(jogg.distance)
  $("#inputDuration").val(jogg.duration)
}

var selected = undefined

function addToTable(index, jogg) {
  var tr =$("<tr></tr>")
      .append(
        $("<th></th>").attr("scope", "col").text(index))
      .append(
        $("<th></th>").text(jogg.date))
      .append(
        $("<th></th>").text(jogg.distance + " km"))
      .append(
        $("<th></th>").text(jogg.duration + " min"))
      .append(
        $("<th></th>").text(jogg.distance / jogg.duration + "km / min"))
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
      addToTable(i + 1, resp[i])
    }
  }, function(err) {
    console.log("error on getting jogging logs")
    console.log(err)
  });
  $('#btn').click(function() {
    console.log("update")
    data = {
      "id": selected.id,
      "date": $("inputData").val(),
      "distance": $("inputDistance").val(),
      "duration": $("inputDuration").val()
    }
    updateJoggingLog(data, function(jogg) {
      console.log("updated jogg")
      console.log(jogg)
    }, function(err) {
      console.log('Error')
      console.log(err)
    })
  })
})
