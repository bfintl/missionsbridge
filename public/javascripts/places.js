(function($){
	$.fn.searchPlaces = function() {
		
		var searchField = this;
		
		var timeout = null;
		var timeoutDelay = 500;
		
		
		var performSearch = function() {

			var searchQuery = searchField.val();
			var searchUrl = "/places/search?q=" + searchQuery;
			
			$.getJSON(searchUrl, function(data) {
				$("#results").html("<ul class='places'></ul>");
			  $.each(data.places.place, function(i, place) {
			    var placeName = "<span class='name'>" + place.name + "</span>";
			    var placeAdmin1 = "<span class='admin1'>" + place.admin1 + "</span>";
			    var placeLink = "<a href='/places/" + place.woeid + "'>" + placeName + ", " + placeAdmin1 + "</a>";
					var placeLi = "<li class='place'>" + placeLink + "</li>";
			    $(placeLi).appendTo("#results .places");
			  })
			});
		};
		
		var triggerSearch = function() {
			clearTimeout(timeout);
			timeout = setTimeout(performSearch, timeoutDelay);
		};

		$("#search").bind("keydown", function(e) {
			triggerSearch();
		});
		
		return this;
	};
})(jQuery);