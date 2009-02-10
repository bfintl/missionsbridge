class PlacesController < ApplicationController
  
  def index
  end
  
  def search
    unless params[:q].blank?
      query = params[:q].is_a?(Array) ? params[:q].join(" ").gsub(/-/, " ") : params[:q]
      @results = Place.yahoo_search(query)
      if @results && @results['places'] && @results['places']['place'].size == 1
        place = @results['places']['place'].first
        redirect_to "/places/#{[place['country'], place['admin1'], place['admin2'], place['admin3'], place['name'], place['woeid']].reject{|x|x.blank?}.uniq.join('/').gsub(/ /,'-')}"
        return
      end
    end
    render :template => 'places/index'
  end
  
  def show
    if params[:woeid] && params[:woeid].last =~ /[0-9]+/
      @place_json = Place.yahoo_place(params[:woeid])
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
