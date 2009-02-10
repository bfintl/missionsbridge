require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PlacesController do

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
      get :show
    end
    it "should respond successfully" do
      get_show
      response.should be_success
    end
  end

end
