require 'open-uri'
module YahooPlace

  def self.included(base)
    base.belongs_to :place_type
    base.validates_presence_of :woeid
    base.before_create :generate_color
    base.before_create :generate_long_name
    base.before_create :generate_parent_names
    base.before_create :generate_permalink
    base.extend ClassMethods
  end

  module ClassMethods

    def yahoo_search(query='')
      search_url = %(http://where.yahooapis.com/v1/places.q('#{CGI::escape(query||"")}');count=10?format=json&appid=#{YAHOO['appid']||''})
      json = ActiveSupport::JSON.decode(open(search_url).read)
      json['places']['place'].collect do |place_json|
        Place.find_or_create_from_json(place_json)
      end if (json && json['places'] && json['places']['place'])
    end

    def yahoo_place(woeid='')
      search_url = %(http://where.yahooapis.com/v1/place/#{woeid}?format=json&appid=#{YAHOO['appid']||''})
      place_json = ActiveSupport::JSON.decode(open(search_url).read)
      Place.find_or_create_from_json(place_json['place']) if (place_json && place_json['place'])
    end

    def find_or_create_from_json(json='')
      Place.find_by_woeid(json['woeid']) || Place.create_from_json(json)
    end

    def create_from_json(json_hash={})
      returning Place.new do |place|
        place.attributes = json_hash.underscore_keys
        place.save!
      end
    end

  end
  
  def generate_permalink
    self.permalink = [country, admin1, admin2, admin3, name, woeid].reject{|x|x.blank?}.uniq.join('/').gsub(/ /,'-')
  end
  
  def generate_long_name
    self.long_name = [ name, admin3, admin2, admin1, country ].reject{|x|x.blank?}.uniq.join(', ')
  end
  
  def generate_parent_names
    self.parent_names = [ admin3, admin2, admin1, country ].reject{|x|x.blank? || x == name}.uniq.join(', ')
  end
  
  def generate_color
    self.color = Digest::MD5.hexdigest(name)[0,6] unless name.blank?
  end
  
  def bounding_box=(bounding_box)
    self.bounding_box_northeast_lat = bounding_box['north_east']['latitude']
    self.bounding_box_northeast_lon = bounding_box['north_east']['longitude']
    self.bounding_box_southwest_lat = bounding_box['south_west']['latitude']
    self.bounding_box_southwest_lon = bounding_box['south_west']['longitude']
  end
  
  def centroid=(centroid)
    self.centroid_lat = centroid['latitude']
    self.centroid_lon = centroid['longitude']
  end
  
  def place_type_name_attrs=(place_type_name_attrs)
    self.place_type = PlaceType.find_or_create_by_code(:code => place_type_name_attrs['code'], :name => place_type_name)
  end
  
  def admin1_attrs=(admin1_attrs)
    admin1_code = admin1_attrs['code']
    admin1_type = admin1_attrs['type']
  end

  def admin2_attrs=(admin2_attrs)
    admin2_code = admin2_attrs['code']
    admin2_type = admin2_attrs['type']
  end

  def admin3_attrs=(admin3_attrs)
    admin3_code = admin3_attrs['code']
    admin3_type = admin3_attrs['type']
  end
  
  def country_attrs=(country_attrs)
    country_code = country_attrs['code']
    country_type = country_attrs['type']
  end
  
  def locality1_attrs=(locality1_attrs)
    locality1_type = locality1_attrs['type']
  end
  
  def locality2_attrs=(locality2_attrs)
    locality2_type = locality2_attrs['type']
  end
  
  def postal_attrs=(postal_attrs)
    postal_type = postal_attrs['type']
  end
  

end