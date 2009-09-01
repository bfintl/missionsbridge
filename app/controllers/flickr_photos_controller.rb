class FlickrPhotosController < ApplicationController

  before_filter :find_place

  def index
    @flickr_photos = @place.flickr_photos
    @place.get_flickr_photos if @flickr_photos.blank?
  end
  
protected
  
  def find_place
    @place = Place.find_by_woeid(params[:place_id])
  end
  
end
