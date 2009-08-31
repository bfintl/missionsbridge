require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Person do

  before(:each) do
    @person = Person.new(
      :login => "test",
      :email => "test@test.test",
      :password => "test",
      :password_confirmation => "test"
    )
  end

  it "should be valid" do
    @person.save!
  end

end
