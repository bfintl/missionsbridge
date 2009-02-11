$("#results").html("<ul class='places'></ul>");

$.getJSON("/places/search?q=San+Diego", function(data) {
  $.each(data.places.place, function(i, place) {
    var place_name = "<span class='name'>" + place.name + "</span>";
    var place_admin1 = "<span class='admin1'>" + place.admin1 + "</span>";
    var place_link = "<a href='/places/" + place.woeid + "'>" + place_name + ", " + place_admin1 + "</a>";
    $("<li class='place'>" + place_link + "</li>").appendTo("#results .places");
  })
});

