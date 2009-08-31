require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PlacesController do
  
  before(:all) do
    Place.stub!(:yahoo_search).and_return(mock_places)
    Place.stub!(:yahoo_place).and_return(mock_place)
    Place.stub!(:find_by_woeid).and_return(mock_place)
    controller.stub!(:place).and_return(mock_place)
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
      get :show, :id => 12345, :permalink => "foo/bar"
    end
    it "should respond successfully" do
      get_show
      response.should be_success
    end
  end
  
  describe "connect" do
    before(:each) do
      Place.stub!(:find_by_woeid).and_return(mock_place)
      controller.stub!(:current_person).and_return(mock_person)
    end
    def post_connect(params={})
      post :connect, params.merge(:id => 12345)
    end
    it "should not fail" do
      post_connect
    end
    it "should require login" do
      controller.should_receive(:require_person)
      post_connect
    end
    it "should record that the current_person has been to this place" do
      mock_person_place_connection.should_receive(:update_attributes).with("been_to" => true)
      post_connect :place_connection => { :been_to => true }
    end
    it "should record that the current_person has contacts here" do
      mock_person_place_connection.should_receive(:update_attributes).with("has_contacts" => true)
      post_connect :place_connection => { :has_contacts => true }
    end
  end

protected

  def mock_place
    @mock_place ||= mock_model(Place,
      :[] => "",
      :new_record? => false
    )
  end
  
  def mock_places
    @mock_places ||= [mock_place]
  end
  
  def mock_person
    @mock_person ||= mock_model(Person,
      :places => mock_places_proxy,
      :person_place_connections => mock_person_place_connections_proxy
    )
  end
  
  def mock_person_place_connections_proxy
    @mock_person_place_connections ||= mock("person place connections proxy",
      :find_or_create_by_place_id => mock_person_place_connection
    )
  end
  
  def mock_person_place_connection
    @mock_person_place_connection ||= mock_model(PersonPlaceConnection,
      :update_attributes => nil
    )
  end
  
  def mock_places_proxy
    @mock_places_proxy ||= mock("places proxy",
      :<< => nil,
      :include? => false
    )
  end

end
