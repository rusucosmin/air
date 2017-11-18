function showJogg(jogg) {
  $("#inputDate").val(jogg.date)
  $("#inputDistance").val(jogg.distance)
  $("#inputDuration").val(jogg.duration)
}

var selected = {}

function addToTable(jogg) {
  var tr =$("<tr></tr>")
      .append(
        $("<th></th>").attr("scope", "col").text(jogg.id))
      .append(
        $("<th class='date'></th>").text(jogg.date))
      .append(
        $("<th class='distance'></th>").text(jogg.distance + " km"))
      .append(
        $("<th class='duration'></th>").text(jogg.duration + " min"))
      .append(
        $("<th class='speed'></th>").text(parseFloat(jogg.distance / jogg.duration).toFixed(2) + "km / min"))
      .attr("id", jogg.id)
  tr.click(function() {
    $("#btnDelete").show()
    showJogg(jogg)
    selected = jogg
  })
  $(".table tbody").append(tr)
}

$(document).ready(function() {
  buildNav("jogging_logs.html")
})
