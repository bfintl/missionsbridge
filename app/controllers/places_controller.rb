class PlacesController < ApplicationController
  
  def index
  end
  
  def search
    unless params[:q].blank?
      query = params[:q].is_a?(Array) ? params[:q].join(" ").gsub(/-/, " ") : params[:q]
      @places = Place.yahoo_search(query)
    end
    respond_to do |format|
      format.html do
        render_or_redirect_search
      end
      format.js   { render :json => @places.to_json }
    end
  end
  
  def show
    if params[:woeid]
      @place = Place.find_by_woeid(params[:woeid]) || Place.yahoo_place(params[:woeid])
    else
      @place = Place.yahoo_place(params[:id])
      redirect_to place_url(@place)
    end
  end

protected


  def render_or_redirect_search
    if @places && @places.size == 1
      redirect_to @places.first
    else
      render :template => 'places/index'
    end
  end

  def place_url(place_json)
    place = [ place_json['country'], place_json['admin1'], place_json['admin2'], place_json['admin3'],
      place_json['name'], place_json['woeid'] ].reject{|x|x.blank?}.uniq.join('/').gsub(/ /,'-')
    "/places/#{place}"
  end
  

end
