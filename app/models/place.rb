require 'digest/md5'

class Place < ActiveRecord::Base
  
  include YahooPlace
  
  def to_param
    permalink
  end
  
  def color
    "##{Digest::MD5.hexdigest(name)[0,6]}"
  end
  
  def long_name
    [ name, admin3, admin2, admin1, country ].reject{|x|x.blank?}.uniq.join(', ')
  end
  
  def parent_names
    [ admin3, admin2, admin1, country ].reject{|x|x.blank?}.uniq.join(', ')
  end
  
protected

  def generate_permalink
    self.permalink = [country, admin1, admin2, admin3, name, woeid].reject{|x|x.blank?}.uniq.join('/').gsub(/ /,'-')
  end
  
end
