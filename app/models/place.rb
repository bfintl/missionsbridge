require 'open-uri'
class Place < ActiveRecord::Base
  def self.search_yahoo(query='')
    search_url = %(http://where.yahooapis.com/v1/places.q('#{CGI::escape(query||"")}')?format=json&appid=#{YAHOO['appid']||''})
    ActiveSupport::JSON.decode(open(search_url).read)
  end
end
