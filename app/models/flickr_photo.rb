class FlickrPhoto < ActiveRecord::Base
  belongs_to :place
  validates_presence_of :place
  
  def self.attributes_from_xml(photo_attributes)
    %w(
      isfriend isfamily ispublic farm server secret
    ).each { |a| photo_attributes.delete(a) }
    photo_attributes['flickr_id'] = photo_attributes.delete('id')
    photo_attributes
  end
end
