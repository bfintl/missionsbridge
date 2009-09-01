class FlickrPhotosController < ApplicationController

  def index
    
  end
  
protected
  
  def find_place
    @place = Place.find_by_woeid(params[:place_id])
  end
  
end
