(function($){

  $.fn.searchPlaces = function() {

    var searchField = this;
    var resultsField = $("#" + this.attr("id").replace("search", "results"));

    var timeout = null;
    var timeoutDelay = 400;
    var throttledDelay = 1000;
    var throttleFactor = 1.5;

    var updatePlacesList = function(data) {
      window.console.log("Updating place list...");
      var placesList = $("<ul class='places'></ul>");
      $.each(data, function(i, item) {
        var place = item.place;
        var placeName = "<span class='name'>" + place.long_name + "</span>";
        var placeColor = "<span style='background-color:#" + place.color + "'>&nbsp;</span>";
        var placeLink = "<a href='/places/" + place.permalink + "'>" +  placeName + "</a>";
        var dataCentroid = "data:centroid-lat='" + place.centroid_lat + "' data:centroid-lon='" + place.centroid_lon + "'";
        var placeLi = "<li class='place' " + dataCentroid + ">" + placeColor + " " + placeLink + "</li>";
        $(placeLi).appendTo(placesList);
      });
      resultsField.html(placesList);
    };

    var performSearch = function() {
      resultsField.html("<div class='indicator'>Please wait&hellip;</div>");

      var searchQuery = searchField.val();
      var searchUrl = "/places/search?q=" + searchQuery;

      $.getJSON(searchUrl, function(data) {
        window.console.log(data);
        if (data && data.length > 0) {
          throttledDelay = 1000;
          updatePlacesList(data);
        } else if (throttledDelay * throttleFactor < 3000) {
          throttledDelay = throttledDelay * throttleFactor;
          triggerSearch(throttledDelay);
        } else {
          throttledDelay = 1000;
          resultsField.html("<div class='indicator'>No results found.</div>");
        }
      });
    };

    var triggerSearch = function(extraTimeoutDelay) {
      clearTimeout(timeout);
      timeout = setTimeout(performSearch, extraTimeoutDelay ? extraTimeoutDelay : timeoutDelay);
    };

    $(searchField).bind("keypress", function(e) {
      triggerSearch();
    });

    return this;
  };
  
})(jQuery);

var sampleLatArray = new Array();
var sampleLonArray = new Array();
var sampleXArray = new Array();
var sampleYArray = new Array();

var pushSampleCoord = function(lat, lon, x, y) {
  sampleLatArray.push(lat);
  sampleLonArray.push(lon);
  sampleXArray.push(x);
  sampleYArray.push(y);
};

var calculateWeights = function(a, samples) {
  var weights = new Array();
  for (var i = 0; i < samples.length; i++) {
    weights[i] = 1.0 / Math.abs(a - samples[i])
  }
  return weights;
};

var weightedMean = function(values, weights) {
  var valueSum  = 0;
  var weightSum = 0;
  for (var i = 0; i < values.length; i++) {
    if (weights[i] == Infinity) {
      return values[i];
    } else {
      valueSum += values[i] * weights[i];
      weightSum += weights[i];
    }
  }
  return valueSum / weightSum;
}

var latLonToXY = function(lat, lon) {
  // 1. calculate weights
  var latWeights = calculateWeights(lat, sampleLatArray)
  var lonWeights = calculateWeights(lat, sampleLonArray)
  // 2. calculate weighted means
  var x = weightedMean(sampleXArray, lonWeights);
  var y = weightedMean(sampleYArray, latWeights);
  // 3. done!
  return [Math.round(x), Math.round(y)];
};
