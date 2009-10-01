(function($){

  $.fn.searchPlaces = function(options) {
    
    if (!options) { options = {} };

    var searchField = this;
    var resultsField = $("#" + this.attr("id").replace("search", "results"));

    var timeout = null;
    var extraSearchTimeout = null;
    var timeoutDelay = 400;
    var throttledDelay = 1000;
    var throttleFactor = 1.5;
    var callback = options.callback;
    var searchInProgress = false;
    var lastQuery = "";

    var updatePlacesList = function(data) {
      $(".place").fadeOut(0.5)
      var placesList = $("<ul class='places'></ul>");
      $.each(data, function(i, item) {
        var place = item.place;
        var placeName = "<span class='name'>" + place.long_name + "</span>";
        var placeColor = "<span style='background-color:#" + place.color + "'>&nbsp;</span>";
        var placeLink = "<a href='/places/" + place.permalink + "'>" +  placeName + "</a>";
        var dataCentroid = "data:centroid-lat='" + place.centroid_lat + "' data:centroid-lon='" + place.centroid_lon + "'";
        var placeLi = "<li class='place' " + dataCentroid + "><span>" + placeColor + " " + placeLink + "</span></li>";
        $(placeLi).appendTo(placesList);
      });
      resultsField.html(placesList);
      if (callback) { callback(); }
    };

    var performSearch = function() {
      var searchQuery = searchField.val();
      var searchUrl = "/places/search?q=" + searchQuery;

      if (searchQuery && searchQuery != "" && searchQuery != lastQuery) {
        lastQuery = searchQuery;
        
        $.getJSON(searchUrl, function(data) {
          if (data && data.length > 0) {
            throttledDelay = 1000;
            updatePlacesList(data);
          } /*else if (throttledDelay * throttleFactor < 3000) {
            throttledDelay = throttledDelay * throttleFactor;
            triggerSearch(throttledDelay);
          } else {
            throttledDelay = 1000;
            resultsField.html("<div class='indicator'>No results found.</div>");
          }*/
          searchInProgress = false;
        });
      } else {
        searchInProgress = false;
        if (searchQuery == null || searchQuery == "")
          resultsField.html("<div class='indicator'></div>");
      }
    };

    var triggerSearch = function(extraTimeoutDelay) {
      if (searchInProgress) {
        clearTimeout(extraSearchTimeout);
        extraSearchTimeout = setTimeout(triggerSearch, extraTimeoutDelay ? extraTimeoutDelay : timeoutDelay);
      } else {
        searchInProgress = true;
        clearTimeout(timeout);
        timeout = setTimeout(performSearch, extraTimeoutDelay ? extraTimeoutDelay : timeoutDelay);
      }
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
    weights[i] = 1.0 / Math.pow(Math.abs(a - samples[i]), 5);
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
  var lonWeights = calculateWeights(lon, sampleLonArray)
  // 2. calculate weighted means
  var x = weightedMean(sampleXArray, lonWeights);
  var y = weightedMean(sampleYArray, latWeights);
  // 3. done!
  return [Math.round(x), Math.round(y)];
};

var setPlacesOnMap = function() {
  $(".place").each(function(i){
    var coords = latLonToXY($(this).attr('data:centroid-lat'), $(this).attr('data:centroid-lon'));
    var offset = $("#world-map").offset();
    var placeWidth = $(this).css("width");
    var placeLeft = coords[0] + offset.left - 30;
    var placeTop = coords[1] + offset.top - 30;
    var placeStyle = {
      position: 'absolute',
      left: placeLeft,
      top: placeTop,
      overflow: 'visible',
      width: placeWidth, // FIXME: figure out a better way to avoid whitespace line breaks without causing z-index issues
      'z-index': (110 - i),
      opacity: 0
    };
    $(this).css(placeStyle);
    // $(this).find("span").css('z-index', (110 - i))
    $(this).fadeTo(0.5, 1 - i / 10)
  });
}
