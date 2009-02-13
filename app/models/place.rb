require 'open-uri'
class Place < ActiveRecord::Base
  
  validates_presence_of :woeid
  
  def self.yahoo_search(query='')
    search_url = %(http://where.yahooapis.com/v1/places.q('#{CGI::escape(query||"")}');count=0?format=json&appid=#{YAHOO['appid']||''})
    json = ActiveSupport::JSON.decode(open(search_url).read)
    json['places']['place'].each do |place_json|
      Place.find_or_create_from_json(place_json)
    end if (json && json['places'] && json['places']['place'])
  end
  
  def self.yahoo_place(woeid='')
    search_url = %(http://where.yahooapis.com/v1/place/#{woeid}?format=json&appid=#{YAHOO['appid']||''})
    place_json = ActiveSupport::JSON.decode(open(search_url).read)
    Place.find_or_create_from_json(place_json['place']) if (place_json && place_json['place'])
  end
  
  def self.find_or_create_from_json(json='')
    Place.find_by_woeid(json['woeid']) || Place.create_from_json(json)
  end
  
  def self.create_from_json(json='')
    returning Place.new do |place|
      place.woeid = json['woeid']
      place.name = json['name']
      place.save
    end
  end
  
end
