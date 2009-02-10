require 'open-uri'
class Place < ActiveRecord::Base
  
  def self.yahoo_search(query='')
    search_url = %(http://where.yahooapis.com/v1/places.q('#{CGI::escape(query||"")}')?format=json&appid=#{YAHOO['appid']||''})
    ActiveSupport::JSON.decode(open(search_url).read)
  end
  
  def self.yahoo_place(woeid='')
    search_url = %(http://where.yahooapis.com/v1/place/#{woeid}?format=json&appid=#{YAHOO['appid']||''})
    ActiveSupport::JSON.decode(open(search_url).read)['place']
  end
  
end
