class PersonPlaceConnection < ActiveRecord::Base

  belongs_to :person
  belongs_to :place

  validates_uniqueness_of :person_id, :scope => :place_id

end
