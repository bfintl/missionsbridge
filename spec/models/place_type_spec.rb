require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PlaceType do
  before(:each) do
    @place_type = PlaceType.new(:name => "Suburb", :code => 22)
  end

  it "should be valid" do
    @place_type.save!
  end

end
