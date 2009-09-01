require 'digest/md5'

class Place < ActiveRecord::Base
  
  include YahooPlace
  
  def to_param
    permalink
  end

  # For example, run this in the back end to populate some FlickrPhoto objects that belong to this place
  # Perhaps then build in some controls to curate these photos, and from there display them via some caching
  def get_flickr_photos
    require 'rexml/document'
    xml = open %(http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=#{YAHOO['flickr_key']}&license=4%2C5%2C6%2C7&safe_search=true&woe_id=#{woeid}&extras=url_m&sort=interestingness-desc)
    doc = REXML::Document.new(xml)
    doc.elements.collect('//photo') do |photo|
      {
        :src => photo.attributes['url_m'],
        :href => "http://flickr.com/photos/#{photo.attributes['owner']}/#{photo.attributes['id']}",
        :title => photo.attributes['title']
      }
    end
  end
  
end

class FlickrPhoto
  def initialize(options)
    
  end
end