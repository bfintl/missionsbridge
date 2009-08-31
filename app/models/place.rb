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
    xml = open %(http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=#{YAHOO['flickr_key']}&license=4%2C5%2C6%2C7&safe_search=true&woe_id=#{woeid}&extras=url_m)
    doc = REXML::Document.new(xml)
    doc.elements.collect('//photo') do |photo|
      # [
      #   "<photo ispublic='1' farm='4' title='Jul 26, 2008' id='2705448828' server='3148' isfamily='0' secret='095864e964' owner='76852421@N00' isfriend='0'/>",
      #   "<photo ispublic='1' farm='4' title='Ramona, Jul 15, 2008' id='2672649327' server='3208' isfamily='0' secret='b8fa965921' owner='76852421@N00' isfriend='0'/>",
      #   "<photo ispublic='1' farm='3' title='Ramona West outskirts' id='2365745470' server='2396' isfamily='0' secret='9e29dd3730' owner='16693950@N00' isfriend='0'/>", "<photo ispublic='1' farm='3' title='East San Diego County' id='2364915137' server='2404' isfamily='0' secret='748a3e1be6' owner='16693950@N00' isfriend='0'/>", "<photo ispublic='1' farm='3' title='East San Diego County' id='2365736864' server='2285' isfamily='0' secret='38821de7f1' owner='16693950@N00' isfriend='0'/>", "<photo ispublic='1' farm='3' title='East San Diego County' id='2365732706' server='2372' isfamily='0' secret='a8b52aa3ce' owner='16693950@N00' isfriend='0'/>", "<photo ispublic='1' farm='4' title='East San Diego County' id='2364899139' server='3037' isfamily='0' secret='b5d514a79b' owner='16693950@N00' isfriend='0'/>", "<photo ispublic='1' farm='3' title='East San Diego County' id='2364903101' server='2004' isfamily='0' secret='cfc32a553f' owner='16693950@N00' isfriend='0'/>", "<photo ispublic='1' farm='3' title='Ramona - North East Countryside' id='2364730763' server='2321' isfamily='0' secret='8776d2d28b' owner='16693950@N00' isfriend='0'/>", "<photo ispublic='1' farm='4' title='Ramona - North East Countryside' id='2365562328' server='3260' isfamily='0' secret='93750c61a3' owner='16693950@N00' isfriend='0'/>", "<photo ispublic='1' farm='3' title='Ramona - North East Countryside' id='2364728469' server='2111' isfamily='0' secret='9c1f0f36f3' owner='16693950@N00' isfriend='0'/>", "<photo ispublic='1' farm='1' title='DSC00333' id='133097597' server='52' isfamily='0' secret='9398754601' owner='48018609@N00' isfriend='0'/>", "<photo ispublic='1' farm='1' title='DSC00335crop' id='133097653' server='55' isfamily='0' secret='969bd614a8' owner='48018609@N00' isfriend='0'/>"]
      photo.attributes['url_m']
    end
  end
  
end

class FlickrPhoto
  def initialize(options)
    
  end
end