class PlacesController < ApplicationController
  
  def index
  end
  
  def search
    unless params[:q].blank?
      query = params[:q].is_a?(Array) ? params[:q].join(" ").gsub(/-/, " ") : params[:q]
      @results = Place.yahoo_search(query)
    end
    respond_to do |format|
      format.html do
        if @results && @results['places'] && @results['places']['place'].size == 1
          place = @results['places']['place'].first
          redirect_to place_url(place)
        else
          render :template => 'places/index'
        end
      end
      format.js   { render :json => @results.to_json }
    end
  end
  
  def show
    @place_json = Place.yahoo_place(params[:woeid] || params[:id])
    unless params[:woeid]
      redirect_to place_url(@place_json)
    end
    
    # Place.find_by_permalink(params[:permalink])
    # if params[:permalink]
    #   Place.find_by_permalink(params[:permalink])
    # else
    #   Place.find(params[:id])
    # end
    # @place = params[:permalink] ? Place.find_by_permalink(params[:permalink]) : Place.find(params[:id])
  end

protected

  def place_url(place_json)
    place = [ place_json['country'], place_json['admin1'], place_json['admin2'], place_json['admin3'],
      place_json['name'], place_json['woeid'] ].reject{|x|x.blank?}.uniq.join('/').gsub(/ /,'-')
    "/places/#{place}"
  end
  

end
