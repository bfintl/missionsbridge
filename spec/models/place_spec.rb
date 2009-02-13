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
    Place.create_from_json(place_json_parsed['place'])
  end
  
  it "should create a bunch of new places from json" do
    places_json_parsed["places"]["place"].each do |place_json|
      Place.create_from_json(place_json).should be_valid
    end
  end
  
  it "should require a WOEID" do
    @place.woeid = nil
    @place.should_not be_valid
  end

end

describe Place do
  
  describe "when creating from JSON" do
    before(:all) do
      @place = Place.create_from_json(place_json_parsed['place'])
    end
    it "should be valid" do
      @place.should be_valid
    end
    it "should have a country" do
      @place.country.should == "United States"
    end
    it "should have a name" do
      @place.name.should_not be_blank
    end
    it "should generate a permalink" do
      @place.permalink.should_not be_blank
    end
    it "should use the permalink for to_param" do
      @place.to_param.should == @place.permalink
    end
    # further tests seem to be redundant at this point. they can be added as functionality really needs to be cemented.
  end

end

def places_json
  @places_json ||= %({"places": {"place": [
    {"boundingBox": {"northEast": {"latitude": 33.112808, "longitude": -116.798203}, "southWest": {"latitude": 32.507488, "longitude": -117.321899}}, "postal": "", "name": "San Diego", "uri": "http://where.yahooapis.com/v1/place/2487889", "placeTypeName": "Town", "woeid": 2487889, "country attrs": {"code": "US", "type": "Country"}, "placeTypeName attrs": {"code": 7}, "centroid": {"latitude": 32.715698, "longitude": -117.16172}, "admin1 attrs": {"code": "US-CA", "type": "State"}, "country": "United States", "locality1 attrs": {"type": "Town"}, "admin1": "California", "lang": "en-US", "locality1": "San Diego", "admin2": "San Diego", "locality2": "", "admin3": "", "admin2 attrs": {"code": "", "type": "County"}}], "total": 37, "start": 0, "count": 1}})
end

def place_json
  @place_json ||= %(
    {"place": {
      "boundingBox": {"northEast": {"latitude": 33.112808, "longitude": -116.798203}, "southWest": {"latitude": 32.507488, "longitude": -117.321899}},
      "postal": "", "name": "San Diego", "uri": "http://where.yahooapis.com/v1/place/2487889",
      "placeTypeName": "Town", "woeid": 2487889, "country attrs": {"code": "US", "type": "Country"},
      "placeTypeName attrs": {"code": 7}, "centroid": {"latitude": 32.715698, "longitude": -117.16172},
      "admin1 attrs": {"code": "US-CA", "type": "State"}, "country": "United States",
      "locality1 attrs": {"type": "Town"}, "admin1": "California", "lang": "en-US",
      "locality1": "San Diego", "admin2": "San Diego", "locality2": "", "admin3": "",
      "admin2 attrs": {"code": "", "type": "County"}
    }}
  )
end

def place_json_parsed
  @place_json_parsed ||= ActiveSupport::JSON.decode(place_json)
end

def places_json_parsed
  @places_json_parsed ||= {"places"=>{"place"=>[      
    {"boundingBox"=>{"northEast"=>{"latitude"=>33.112808, "longitude"=>-116.798203}, "southWest"=>{"latitude"=>32.507488, "longitude"=>-117.321899}}, "postal"=>"",
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/2487889", "placeTypeName"=>"Town", "woeid"=>2487889, "country attrs"=>{"code"=>"US", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>32.715698, "longitude"=>-117.16172}, "admin1 attrs"=>{"code"=>"US-CA", "type"=>"State"}, "country"=>"United States", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"California", "lang"=>"en-US", "locality1"=>"San Diego", "admin2"=>"San Diego", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"County"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>18.832649, "longitude"=>-98.310913}, "southWest"=>{"latitude"=>18.81447, "longitude"=>-98.330109}}, "postal"=>"743", 
    "name"=>"San Diego la Mesa Tochimiltzingo", "uri"=>"http://where.yahooapis.com/v1/place/142233", "placeTypeName"=>"Town", "woeid"=>142233, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>18.823561, "longitude"=>-98.320511}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Puebla", "lang"=>"en-US", "locality1"=>"San Diego la Mesa Tochimiltzingo", "admin2"=>"San Diego la Mesa Tochimiltzingo", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>27.773609, "longitude"=>-98.2285}, "southWest"=>{"latitude"=>27.746929, "longitude"=>-98.249939}}, "postal"=>"78384", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/2487940", "placeTypeName"=>"Town", "woeid"=>2487940, "postal attrs"=>{"type"=>"Zip Code"}, "country attrs"=>{"code"=>"US", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>27.76429, "longitude"=>-98.23938}, "admin1 attrs"=>{"code"=>"US-TX", "type"=>"State"}, "country"=>"United States", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Texas", "lang"=>"en-US", "locality1"=>"San Diego", "admin2"=>"Duval", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"County"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>40.395809, "longitude"=>-3.65685}, "southWest"=>{"latitude"=>40.379189, "longitude"=>-3.67867}}, "postal"=>"28018", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/20219909", "placeTypeName"=>"Suburb", "woeid"=>20219909, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"ES", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>22}, "centroid"=>{"latitude"=>40.387501, "longitude"=>-3.66776}, "admin1 attrs"=>{"code"=>"ES-M", "type"=>"Autonomous Community"}, "country"=>"Spain", "locality1 attrs"=>{"type"=>"Town"}, "locality2 attrs"=>{"type"=>"Suburb"}, "admin1"=>"Madrid", "lang"=>"en-US", "locality1"=>"Madrid", "admin2"=>"Madrid", "locality2"=>"San Diego", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Province"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>6.75702, "longitude"=>-75.759628}, "southWest"=>{"latitude"=>6.74298, "longitude"=>-75.773773}}, "postal"=>"", 
    "name"=>"La Placita", "uri"=>"http://where.yahooapis.com/v1/place/359723", "placeTypeName"=>"Town", "woeid"=>359723, "country attrs"=>{"code"=>"CO", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>6.75, "longitude"=>-75.766701}, "admin1 attrs"=>{"code"=>"", "type"=>"Department"}, "country"=>"Colombia", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Antioquia", "lang"=>"en-US", "locality1"=>"La Placita", "admin2"=>"Liborina", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>36.326092, "longitude"=>-5.2492}, "southWest"=>{"latitude"=>36.30349, "longitude"=>-5.27913}}, "postal"=>"11312", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/20225794", "placeTypeName"=>"Town", "woeid"=>20225794, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"ES", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>36.31591, "longitude"=>-5.25673}, "admin1 attrs"=>{"code"=>"ES-AN", "type"=>"Autonomous Community"}, "country"=>"Spain", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Andalucia", "lang"=>"en-US", "locality1"=>"San Diego", "admin2"=>"Cadiz", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Province"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>10.30814, "longitude"=>-73.188362}, "southWest"=>{"latitude"=>10.2893, "longitude"=>-73.20752}}, "postal"=>"", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/368392", "placeTypeName"=>"Town", "woeid"=>368392, "country attrs"=>{"code"=>"CO", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>10.29872, "longitude"=>-73.197937}, "admin1 attrs"=>{"code"=>"", "type"=>"Department"}, "country"=>"Colombia", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Cesar", "lang"=>"en-US", "locality1"=>"San Diego", "admin2"=>"San Diego", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>5.67566, "longitude"=>-74.882156}, "southWest"=>{"latitude"=>5.65748, "longitude"=>-74.900436}}, "postal"=>"", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/365327", "placeTypeName"=>"Town", "woeid"=>365327, "country attrs"=>{"code"=>"CO", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>5.66657, "longitude"=>-74.891296}, "admin1 attrs"=>{"code"=>"", "type"=>"Department"}, "country"=>"Colombia", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Caldas", "lang"=>"en-US", "locality1"=>"San Diego", "admin2"=>"Samana", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>19.50102, "longitude"=>-99.671303}, "southWest"=>{"latitude"=>19.48284, "longitude"=>-99.690582}}, "postal"=>"508", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/142215", "placeTypeName"=>"Town", "woeid"=>142215, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>19.49193, "longitude"=>-99.680939}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Mexico", "lang"=>"en-US", "locality1"=>"San Diego", "admin2"=>"Temoaya", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>-21.39197, "longitude"=>-64.208076}, "southWest"=>{"latitude"=>-21.40802, "longitude"=>-64.225319}}, "postal"=>"", 
    "name"=>"San Diego Sud", "uri"=>"http://where.yahooapis.com/v1/place/343490", "placeTypeName"=>"Town", "woeid"=>343490, "country attrs"=>{"code"=>"BO", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>-21.4, "longitude"=>-64.216698}, "admin1 attrs"=>{"code"=>"", "type"=>"Department"}, "country"=>"Bolivia", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Tarija", "lang"=>"en-US", "locality1"=>"San Diego Sud", "admin2"=>"", "locality2"=>"", "admin3"=>""}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>9.90909, "longitude"=>-83.990768}, "southWest"=>{"latitude"=>9.89091, "longitude"=>-84.009232}}, "postal"=>"2250", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/59354", "placeTypeName"=>"Town", "woeid"=>59354, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"CR", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>9.9, "longitude"=>-84}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Costa Rica", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Cartago", "lang"=>"en-US", "locality1"=>"San Diego", "admin2"=>"La Uni\\u00f3n", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"County"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>10.27012, "longitude"=>-67.941757}, "southWest"=>{"latitude"=>10.25608, "longitude"=>-67.956039}}, "postal"=>"", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/468334", "placeTypeName"=>"Town", "woeid"=>468334, "country attrs"=>{"code"=>"VE", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>10.2631, "longitude"=>-67.948898}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Venezuela", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Carabobo", "lang"=>"en-US", "locality1"=>"San Diego", "admin2"=>"San Diego", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"County"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>37.4216, "longitude"=>-5.95754}, "southWest"=>{"latitude"=>37.40498, "longitude"=>-5.97846}}, "postal"=>"41008", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/20220154", "placeTypeName"=>"Suburb", "woeid"=>20220154, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"ES", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>22}, "centroid"=>{"latitude"=>37.413288, "longitude"=>-5.968}, "admin1 attrs"=>{"code"=>"ES-AN", "type"=>"Autonomous Community"}, "country"=>"Spain", "locality1 attrs"=>{"type"=>"Town"}, "locality2 attrs"=>{"type"=>"Suburb"}, "admin1"=>"Andalucia", "lang"=>"en-US", "locality1"=>"Seville", "admin2"=>"Seville", "locality2"=>"San Diego", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Province"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>-28.73794, "longitude"=>-58.650188}, "southWest"=>{"latitude"=>-28.756121, "longitude"=>-58.670929}}, "postal"=>"W3446", 
    "name"=>"Pedro R. Fern\\u00e1ndez", "uri"=>"http://where.yahooapis.com/v1/place/466090", "placeTypeName"=>"Town", "woeid"=>466090, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"AR", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>-28.74703, "longitude"=>-58.660561}, "admin1 attrs"=>{"code"=>"", "type"=>"Province"}, "country"=>"Argentina", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Corrientes", "lang"=>"en-US", "locality1"=>"Pedro R. Fern\\u00e1ndez", "admin2"=>"San Roque", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Department"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>10.38712, "longitude"=>-67.917488}, "southWest"=>{"latitude"=>10.23155, "longitude"=>-67.992149}}, "postal"=>"", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/26804615", "placeTypeName"=>"County", "woeid"=>26804615, "country attrs"=>{"code"=>"VE", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>9}, "centroid"=>{"latitude"=>10.30933, "longitude"=>-67.954819}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Venezuela", "admin1"=>"Carabobo", "lang"=>"en-US", "locality1"=>"", "admin2"=>"San Diego", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"County"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>28.59395, "longitude"=>-105.562553}, "southWest"=>{"latitude"=>28.575769, "longitude"=>-105.583252}}, "postal"=>"329", 
    "name"=>"San Diego de Alcal\\u00e1", "uri"=>"http://where.yahooapis.com/v1/place/142223", "placeTypeName"=>"Town", "woeid"=>142223, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>28.58486, "longitude"=>-105.572899}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Chihuahua", "lang"=>"en-US", "locality1"=>"San Diego de Alcal\\u00e1", "admin2"=>"Aldama", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>30.25909, "longitude"=>-108.00618}, "southWest"=>{"latitude"=>30.24091, "longitude"=>-108.027222}}, "postal"=>"318", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/142217", "placeTypeName"=>"Town", "woeid"=>142217, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>30.25, "longitude"=>-108.016701}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Chihuahua", "lang"=>"en-US", "locality1"=>"San Diego", "admin2"=>"Casas Grandes", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>14.79032, "longitude"=>-89.776031}, "southWest"=>{"latitude"=>14.77628, "longitude"=>-89.790573}}, "postal"=>"19008", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/85580", "placeTypeName"=>"Town", "woeid"=>85580, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"GT", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>14.7833, "longitude"=>-89.783302}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Guatemala", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Zacapa", "lang"=>"en-US", "locality1"=>"San Diego", "admin2"=>"San Diego", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"County"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>20.025789, "longitude"=>-100.857018}, "southWest"=>{"latitude"=>20.00761, "longitude"=>-100.876381}}, "postal"=>"386", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/142207", "placeTypeName"=>"Town", "woeid"=>142207, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>20.016701, "longitude"=>-100.866699}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Guanajuato", "lang"=>"en-US", "locality1"=>"San Diego", "admin2"=>"Acambaro", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>24.391291, "longitude"=>-107.320023}, "southWest"=>{"latitude"=>24.37311, "longitude"=>-107.339981}}, "postal"=>"800", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/142188", "placeTypeName"=>"Town", "woeid"=>142188, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>24.3822, "longitude"=>-107.330002}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Sinaloa", "lang"=>"en-US", "locality1"=>"San Diego", "admin2"=>"Culiacan", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>24.00909, "longitude"=>-103.956749}, "southWest"=>{"latitude"=>23.99091, "longitude"=>-103.976646}}, "postal"=>"348", 
    "name"=>"San Diego de Alcal\\u00e1", "uri"=>"http://where.yahooapis.com/v1/place/142224", "placeTypeName"=>"Town", "woeid"=>142224, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>24, "longitude"=>-103.966698}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Durango", "lang"=>"en-US", "locality1"=>"San Diego de Alcal\\u00e1", "admin2"=>"Poanas", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>18.4459, "longitude"=>-97.358307}, "southWest"=>{"latitude"=>18.427719, "longitude"=>-97.377472}}, "postal"=>"757", 
    "name"=>"San Diego Chalma", "uri"=>"http://where.yahooapis.com/v1/place/142220", "placeTypeName"=>"Town", "woeid"=>142220, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>18.43681, "longitude"=>-97.367889}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Puebla", "lang"=>"en-US", "locality1"=>"San Diego Chalma", "admin2"=>"Tehuacan", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>20.47983, "longitude"=>-97.705498}, "southWest"=>{"latitude"=>20.461651, "longitude"=>-97.724899}}, "postal"=>"730", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/142216", "placeTypeName"=>"Town", "woeid"=>142216, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>20.470739, "longitude"=>-97.715202}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Puebla", "lang"=>"en-US", "locality1"=>"San Diego", "admin2"=>"Venustiano Carranza", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>25.21854, "longitude"=>-110.696068}, "southWest"=>{"latitude"=>25.204741, "longitude"=>-110.706947}}, "postal"=>"236", 
    "name"=>"San Diego Isla", "uri"=>"http://where.yahooapis.com/v1/place/12484591", "placeTypeName"=>"Island", "woeid"=>12484591, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>13}, "centroid"=>{"latitude"=>25.211639, "longitude"=>-110.701508}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "admin1"=>"Baja California Sur", "lang"=>"en-US", "locality1"=>"", "admin2"=>"Loreto", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>20.435949, "longitude"=>-103.403503}, "southWest"=>{"latitude"=>20.418421, "longitude"=>-103.418472}}, "postal"=>"456", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/55884332", "placeTypeName"=>"Town", "woeid"=>55884332, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>20.42613, "longitude"=>-103.408012}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Jalisco", "lang"=>"en-US", "locality1"=>"San Diego", "admin2"=>"Tlajomulco de Zuniga", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>25.689569, "longitude"=>-100.224899}, "southWest"=>{"latitude"=>25.671391, "longitude"=>-100.245079}}, "postal"=>"671", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/55898849", "placeTypeName"=>"Town", "woeid"=>55898849, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>7}, "centroid"=>{"latitude"=>25.680479, "longitude"=>-100.234993}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "admin1"=>"Nuevo Leon", "lang"=>"en-US", "locality1"=>"San Diego", "admin2"=>"Guadalupe", "locality2"=>"", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>17.953939, "longitude"=>-94.911728}, "southWest"=>{"latitude"=>17.94108, "longitude"=>-94.925247}}, "postal"=>"960", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/55911095", "placeTypeName"=>"Suburb", "woeid"=>55911095, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>22}, "centroid"=>{"latitude"=>17.94751, "longitude"=>-94.918488}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "locality2 attrs"=>{"type"=>"Suburb"}, "admin1"=>"Veracruz-Llave", "lang"=>"en-US", "locality1"=>"Acayucan", "admin2"=>"Acayucan", "locality2"=>"San Diego", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>21.14563, "longitude"=>-100.938438}, "southWest"=>{"latitude"=>21.132771, "longitude"=>-100.952217}}, "postal"=>"378", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/55901494", "placeTypeName"=>"Suburb", "woeid"=>55901494, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>22}, "centroid"=>{"latitude"=>21.1392, "longitude"=>-100.945328}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "locality2 attrs"=>{"type"=>"Suburb"}, "admin1"=>"Guanajuato", "lang"=>"en-US", "locality1"=>"S. Diego de la Union", "admin2"=>"Dolores Hidalgo", "locality2"=>"San Diego", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>24.01473, "longitude"=>-104.662872}, "southWest"=>{"latitude"=>24.001869, "longitude"=>-104.676949}}, "postal"=>"340", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/55900770", "placeTypeName"=>"Suburb", "woeid"=>55900770, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>22}, "centroid"=>{"latitude"=>24.008301, "longitude"=>-104.669907}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "locality2 attrs"=>{"type"=>"Suburb"}, "admin1"=>"Durango", "lang"=>"en-US", "locality1"=>"Durango", "admin2"=>"Durango", "locality2"=>"San Diego", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>18.980631, "longitude"=>-99.575638}, "southWest"=>{"latitude"=>18.96777, "longitude"=>-99.589241}}, "postal"=>"524", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/55905529", "placeTypeName"=>"Suburb", "woeid"=>55905529, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>22}, "centroid"=>{"latitude"=>18.974199, "longitude"=>-99.582443}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "locality2 attrs"=>{"type"=>"Suburb"}, "admin1"=>"Mexico", "lang"=>"en-US", "locality1"=>"Malinalco", "admin2"=>"Tenancingo", "locality2"=>"San Diego", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>19.896971, "longitude"=>-102.825699}, "southWest"=>{"latitude"=>19.884109, "longitude"=>-102.839378}}, "postal"=>"495", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/55892807", "placeTypeName"=>"Suburb", "woeid"=>55892807, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>22}, "centroid"=>{"latitude"=>19.890539, "longitude"=>-102.832542}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "locality2 attrs"=>{"type"=>"Suburb"}, "admin1"=>"Jalisco", "lang"=>"en-US", "locality1"=>"Valle de Ju\\u00e1rez", "admin2"=>"Quitupan", "locality2"=>"San Diego", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>20.14563, "longitude"=>-90.16848}, "southWest"=>{"latitude"=>20.132771, "longitude"=>-90.182182}}, "postal"=>"248", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/55908388", "placeTypeName"=>"Suburb", "woeid"=>55908388, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>22}, "centroid"=>{"latitude"=>20.1392, "longitude"=>-90.175331}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "locality2 attrs"=>{"type"=>"Suburb"}, "admin1"=>"Campeche", "lang"=>"en-US", "locality1"=>"Hecelchak\\u00e1n", "admin2"=>"Hecelchakan", "locality2"=>"San Diego", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>17.55373, "longitude"=>-98.566528}, "southWest"=>{"latitude"=>17.540871, "longitude"=>-98.580009}}, "postal"=>"413", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/55914707", "placeTypeName"=>"Suburb", "woeid"=>55914707, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>22}, "centroid"=>{"latitude"=>17.5473, "longitude"=>-98.573273}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "locality2 attrs"=>{"type"=>"Suburb"}, "admin1"=>"Guerrero", "lang"=>"en-US", "locality1"=>"Tlalixtaquilla", "admin2"=>"Tlapa de Comonfort", "locality2"=>"San Diego", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>18.47097, "longitude"=>-95.298058}, "southWest"=>{"latitude"=>18.458111, "longitude"=>-95.311623}}, "postal"=>"958", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/55912048", "placeTypeName"=>"Suburb", "woeid"=>55912048, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>22}, "centroid"=>{"latitude"=>18.46454, "longitude"=>-95.30484}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "locality2 attrs"=>{"type"=>"Suburb"}, "admin1"=>"Veracruz-Llave", "lang"=>"en-US", "locality1"=>"Santiago Tuxtla", "admin2"=>"Santiago Tuxtla", "locality2"=>"San Diego", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>19.26861, "longitude"=>-99.093689}, "southWest"=>{"latitude"=>19.255751, "longitude"=>-99.107307}}, "postal"=>"160", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/55897776", "placeTypeName"=>"Suburb", "woeid"=>55897776, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>22}, "centroid"=>{"latitude"=>19.26218, "longitude"=>-99.100502}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "locality2 attrs"=>{"type"=>"Suburb"}, "admin1"=>"Distrito Federal", "lang"=>"en-US", "locality1"=>"Xochimilco", "admin2"=>"Cuauhtemoc", "locality2"=>"San Diego", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>24.528891, "longitude"=>-104.772636}, "southWest"=>{"latitude"=>24.516029, "longitude"=>-104.786781}}, "postal"=>"344", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/55920143", "placeTypeName"=>"Suburb", "woeid"=>55920143, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>22}, "centroid"=>{"latitude"=>24.522461, "longitude"=>-104.779709}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "locality2 attrs"=>{"type"=>"Suburb"}, "admin1"=>"Durango", "lang"=>"en-US", "locality1"=>"Nuevo Ideal", "admin2"=>"Canatlan", "locality2"=>"San Diego", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}, 
    {"boundingBox"=>{"northEast"=>{"latitude"=>19.86034, "longitude"=>-97.354462}, "southWest"=>{"latitude"=>19.847481, "longitude"=>-97.368118}}, "postal"=>"738", 
    "name"=>"San Diego", "uri"=>"http://where.yahooapis.com/v1/place/55907788", "placeTypeName"=>"Suburb", "woeid"=>55907788, "postal attrs"=>{"type"=>"Postal Code"}, "country attrs"=>{"code"=>"MX", "type"=>"Country"}, "placeTypeName attrs"=>{"code"=>22}, "centroid"=>{"latitude"=>19.85391, "longitude"=>-97.36129}, "admin1 attrs"=>{"code"=>"", "type"=>"State"}, "country"=>"Mexico", "locality1 attrs"=>{"type"=>"Town"}, "locality2 attrs"=>{"type"=>"Suburb"}, "admin1"=>"Puebla", "lang"=>"en-US", "locality1"=>"Teziutl\\u00e1n", "admin2"=>"Teziutlan", "locality2"=>"San Diego", "admin3"=>"", "admin2 attrs"=>{"code"=>"", "type"=>"Municipality"}}
  ], "total"=>37, "start"=>0, "count"=>37}}
end
