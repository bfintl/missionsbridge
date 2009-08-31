require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PersonPlaceConnection do
  before(:each) do
    @person_place_connection = PersonPlaceConnection.new
  end

  it "should be valid" do
    @person_place_connection.save!
  end
  
  it "should not allow duplicates" do
    @person_place_connection.save!
    duplicate = PersonPlaceConnection.new(@person_place_connection.attributes)
    duplicate.should_not be_valid
  end

end
