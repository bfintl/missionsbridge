class PlacesController < ApplicationController
  
  def index
  end
  
  def search
    @results = Place.search_yahoo(params[:q]) unless params[:q].blank?
    render :template => 'places/index'
  end
  
  def show
    # Place.find_by_permalink(params[:permalink])
    # if params[:permalink]
    #   Place.find_by_permalink(params[:permalink])
    # else
    #   Place.find(params[:id])
    # end
    # @place = params[:permalink] ? Place.find_by_permalink(params[:permalink]) : Place.find(params[:id])
  end

end
