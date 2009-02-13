require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PlacesController do
  
  before(:all) do
    Place.stub!(:yahoo_search).and_return(mock_places)
    Place.stub!(:yahoo_place).and_return(mock_place)
  end

  describe "index" do
    def get_index
      get :index
    end
    it "should respond successfully" do
      get_index
      response.should be_success
    end
  end
  
  describe "search" do
    def get_search
      get :search
    end
    it "should respond successfully" do
      response.should be_success
    end
  end
  
  describe "show" do
    def get_show
      get :show, :woeid => 12345
    end
    it "should respond successfully" do
      get_show
      response.should be_success
    end
  end

protected

  def mock_place
    @mock_place ||= mock_model(Place)
  end
  
  def mock_places
    @mock_places ||= [mock_place]
  end

end
