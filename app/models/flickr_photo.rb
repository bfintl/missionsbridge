class FlickrPhoto < ActiveRecord::Base
  belongs_to :place
  validates_presence_of :place
  
  def self.attributes_from_xml(photo_attributes)
    returning Hash.new do |attributes|
      %w(isfriend isfamily ispublic farm server secret).each { |a| photo_attributes.delete(a) }
      photo_attributes.collect do |key, val|
        attributes[key.to_sym] = val
      end
      attributes[:flickr_id] = attributes.delete(:id)
    end
  end
  
  def href
    "http://flickr.com/photos/#{owner}/#{flickr_id}"
  end
end
