require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Place do
  before(:each) do
    @place = Place.new()
  end

  it "should be valid" do
    @place.save!
  end
  
protected
  
  def place_json
    %({"places": {"place": [{"boundingBox": {"northEast": {"latitude": 33.112808, "longitude": -116.798203}, "southWest": {"latitude": 32.507488, "longitude": -117.321899}}, "postal": "", "name": "San Diego", "uri": "http://where.yahooapis.com/v1/place/2487889", "placeTypeName": "Town", "woeid": 2487889, "country attrs": {"code": "US", "type": "Country"}, "placeTypeName attrs": {"code": 7}, "centroid": {"latitude": 32.715698, "longitude": -117.16172}, "admin1 attrs": {"code": "US-CA", "type": "State"}, "country": "United States", "locality1 attrs": {"type": "Town"}, "admin1": "California", "lang": "en-US", "locality1": "San Diego", "admin2": "San Diego", "locality2": "", "admin3": "", "admin2 attrs": {"code": "", "type": "County"}}], "total": 37, "start": 0, "count": 1}})
  end
  
end


