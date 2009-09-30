require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FlickrPhotosController do

  describe "index of all photos" do
    def get_index
      get :index
    end
    it "should be a success" do
      get_index
      response.should be_success
    end
    it "should look for all flickr photos" do
      FlickrPhoto.should_receive(:find)
      get_index
    end
  end
  
  describe "index of a place's photos" do
    before(:each) do
      Place.stub!(:find).and_return(mock_place)
    end
    def get_index
      get :index, :place_id => 1
    end
    it "should be successful" do
      get_index
      response.should be_success
    end
    it "should receive photos from a place" do
      mock_place.should_receive(:flickr_photos)
      get_index
    end
  end

protected

  def mock_place
    @mock_place ||= mock_model(Place,
      :flickr_photos => nil,
      :get_flickr_photos => nil
    )
  end

end
