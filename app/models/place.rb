require 'digest/md5'

class Place < ActiveRecord::Base
  include YahooPlace
  
  has_many :flickr_photos
  after_create :get_flickr_photos
  
  has_many :person_place_connections
  has_many :people, :through => :person_place_connections
  
  def to_param
    permalink
  end

  # For example, run this in the back end to populate some FlickrPhoto objects that belong to this place
  # Perhaps then build in some controls to curate these photos, and from there display them via some caching
  def get_flickr_photos
    require 'rexml/document'
    xml = open(%(http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=#{YAHOO['flickr_key']}&license=4%2C5%2C6%2C7&safe_search=true&woe_id=#{woeid}&extras=url_m&sort=interestingness-desc))
    doc = REXML::Document.new(xml)
    doc.elements.collect('//photo') do |photo_element|
      photo_attributes = { :place_id => self.id }.merge(FlickrPhoto.attributes_from_xml(photo_element.attributes))
      FlickrPhoto.find_or_create_by_flickr_id_and_place_id(photo_attributes)
    end
  end

  handle_asynchronously :get_flickr_photos
  
end