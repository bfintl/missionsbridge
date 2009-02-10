class PlacesController < ApplicationController
  
  def index
  end
  
  def search
    @results = Place.yahoo_search(params[:q]) unless params[:q].blank?
    render :template => 'places/index'
  end
  
  def show
    if params[:permalink] && params[:permalink].last =~ /[0-9]+/
      @place_json = Place.yahoo_place(params[:permalink].last)
    end
    
    # Place.find_by_permalink(params[:permalink])
    # if params[:permalink]
    #   Place.find_by_permalink(params[:permalink])
    # else
    #   Place.find(params[:id])
    # end
    # @place = params[:permalink] ? Place.find_by_permalink(params[:permalink]) : Place.find(params[:id])
  end

end
