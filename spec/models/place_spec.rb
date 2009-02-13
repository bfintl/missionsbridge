require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Place do

  before(:all) do
    Place.stub!(:open).with(nil)
  end
  
  before(:each) do
    @place = Place.new({
      :woeid => 12345
    })
  end

  it "should be valid" do
    @place.save!
  end
  
  it "should search Yahoo with a search string" do
    Place.stub!(:open).and_return(mock("places json", :read => places_json))
    Place.should_receive(:find_or_create_from_json)
    Place.yahoo_search("test")
  end
  
  it "should find Yahoo Place JSON from a WOEID" do
    Place.stub!(:open).and_return(mock("place json", :read => place_json))
    Place.should_receive(:find_or_create_from_json)
    Place.yahoo_place(2487889)
  end
  
  it "should create a new place from json" do
    Place.create_from_json(place_json_parsed)
  end
  
  it "should require a WOEID" do
    @place.woeid = nil
    @place.should_not be_valid
  end
  
protected
  
  def places_json
    @places_json ||= %({"places": {"place": [{"boundingBox": {"northEast": {"latitude": 33.112808, "longitude": -116.798203}, "southWest": {"latitude": 32.507488, "longitude": -117.321899}}, "postal": "", "name": "San Diego", "uri": "http://where.yahooapis.com/v1/place/2487889", "placeTypeName": "Town", "woeid": 2487889, "country attrs": {"code": "US", "type": "Country"}, "placeTypeName attrs": {"code": 7}, "centroid": {"latitude": 32.715698, "longitude": -117.16172}, "admin1 attrs": {"code": "US-CA", "type": "State"}, "country": "United States", "locality1 attrs": {"type": "Town"}, "admin1": "California", "lang": "en-US", "locality1": "San Diego", "admin2": "San Diego", "locality2": "", "admin3": "", "admin2 attrs": {"code": "", "type": "County"}}], "total": 37, "start": 0, "count": 1}})
  end
  
  def places_json_parsed
    @places_json_parsed ||= ActiveSupport::JSON.decode(places_json)
  end
  
  def place_json
    @place_json ||= %({"place": [{"boundingBox": {"northEast": {"latitude": 33.112808, "longitude": -116.798203}, "southWest": {"latitude": 32.507488, "longitude": -117.321899}}, "postal": "", "name": "San Diego", "uri": "http://where.yahooapis.com/v1/place/2487889", "placeTypeName": "Town", "woeid": 2487889, "country attrs": {"code": "US", "type": "Country"}, "placeTypeName attrs": {"code": 7}, "centroid": {"latitude": 32.715698, "longitude": -117.16172}, "admin1 attrs": {"code": "US-CA", "type": "State"}, "country": "United States", "locality1 attrs": {"type": "Town"}, "admin1": "California", "lang": "en-US", "locality1": "San Diego", "admin2": "San Diego", "locality2": "", "admin3": "", "admin2 attrs": {"code": "", "type": "County"}}], "total": 37, "start": 0, "count": 1})
  end
  
  def place_json_parsed
    @place_json_parsed ||= ActiveSupport::JSON.decode(place_json)
  end
  
end


