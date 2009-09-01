class Person < ActiveRecord::Base
  acts_as_authentic
  
  has_many :person_place_connections
  has_many :places, :through => :person_place_connections
  
  
  def been_to?(place)
    person_place_connections.count(:conditions => {:place_id => place.id, :been_to => true}) > 0
  end
  
  def contacts_in?(place)
    person_place_connections.count(:conditions => {:place_id => place.id, :has_contacts => true}) > 0
  end
  
  def wants_to_go_to?(place)
    person_place_connections.count(:conditions => {:place_id => place.id, :wants_to_go => true}) > 0
  end
  
  def update_place_connection_hierarchy_for(place, options={})
    # TODO: need an internet connection to test this stuff
    place.find_or_create_parent!
    if place.parent
      person_place_connections.find_or_create_by_place_id({:place_id => parent.id}.merge(options))
      update_place_connection_hierarchy_for(parent)
    end
  end
  
end
