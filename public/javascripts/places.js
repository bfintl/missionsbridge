(function($){
	$.fn.searchPlaces = function() {

		var searchField = this;
		var resultsField = $("#" + this.attr("id").replace("search", "results"));

		var timeout = null;
		var timeoutDelay = 400;

		var performSearch = function() {
			resultsField.html("<div class='indicator'>Please wait...</div>");

			var searchQuery = searchField.val();
			var searchUrl = "/places/search?q=" + searchQuery;

			$.getJSON(searchUrl, function(data) {
				var placesList = $("<ul class='places'></ul>");
			  $.each(data, function(i, item) {
					var place = item.place;
			    var placeName = "<span class='name'>" + place.long_name + "</span>";
					var placeColor = "<span style='background:#" + place.color + "'>&nbsp;</span>";
			    var placeLink = "<a href='/places/" + place.permalink + "'>" +  placeName + "</a>";
					var placeLi = "<li class='place'>" + placeColor + " " + placeLink + "</li>";
			    $(placeLi).appendTo(placesList);
			  });
				resultsField.html(placesList);
			});
		};

		var triggerSearch = function() {
			clearTimeout(timeout);
			timeout = setTimeout(performSearch, timeoutDelay);
		};

		$(searchField).bind("keypress", function(e) {
			triggerSearch();
		});

		return this;
	};
})(jQuery);