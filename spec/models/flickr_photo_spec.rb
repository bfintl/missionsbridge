require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FlickrPhoto do
  before(:each) do
    @flickr_photo = FlickrPhoto.new(
      :place => mock_place
    )
  end

  it "should be valid" do
    @flickr_photo.save
  end
  
  it "should belong to a place" do
    @flickr_photo.place_id = nil
    @flickr_photo.place = nil
    @flickr_photo.should_not be_valid
  end
  
  it "should be createable from Flickr's xml search response" do
    mock_xml_doc.elements.each("//photo") do |photo_element|
      photo_attributes = {:place_id => mock_place.id}.merge(FlickrPhoto.attributes_from_xml(photo_element.attributes))
      FlickrPhoto.find_or_create_by_flickr_id_and_place_id(photo_attributes)
    end
  end
  
protected

  def mock_place
    @mock_place ||= mock_model(Place)
  end
  
  def mock_xml_response
    %(
      <?xml version="1.0" encoding="utf-8" ?>
      <rsp stat="ok">
      <photos page="1" pages="1" perpage="250" total="2">
      	<photo id="489388602" owner="72772620@N00" secret="585d9379d2" server="210" farm="1" title="Hike to Bedford Peak" ispublic="1" isfriend="0" isfamily="0" url_m="http://farm1.static.flickr.com/210/489388602_585d9379d2.jpg" height_m="500" width_m="375" />
      </photos>
      </rsp>
    )
  end
  
  def mock_xml_doc
    @mock_xml_doc ||= REXML::Document.new(mock_xml_response)
  end
  
end
