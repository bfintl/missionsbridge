require 'digest/md5'

class Place < ActiveRecord::Base
  
  include YahooPlace
  
  def to_param
    permalink
  end
  
end
