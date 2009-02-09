require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PlacesController do

  describe "index" do
    it "should respond successfully" do
      get :index
      response.should be_success
    end
  end
  
  describe "search" do
    it "should respond successfully" do
      get :search
      response.should be_success
    end
  end
  
  describe "show" do
    it "should respond successfully" do
      get :show
    end
  end

end
