class FlickrPhotosController < ApplicationController

  before_filter :find_place

  def index
    find_flickr_photos
  end
  
  def update
    @flickr_photo = FlickrPhoto.find(params[:id])
    @flickr_photo.update_attributes(params[:flickr_photo])
    redirect_to :back
  end
  
protected
  
  def find_place
    @place = Place.find_by_woeid(params[:place_id])
  end
  
  def find_flickr_photos
    if @place
      @flickr_photos = @place.flickr_photos
      @place.get_flickr_photos if @flickr_photos.blank?
    else
      @flickr_photos = FlickrPhoto.unreviewed.find(:all, :limit => 3)
    end
  end
  
end
