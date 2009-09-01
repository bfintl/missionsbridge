class PlacesController < ApplicationController
  
  before_filter :require_person, :only => :connect
  before_filter :find_place, :only => [ :show, :connect ]
  
  def index
  end
  
  def search
    unless params[:q].blank?
      params[:q] = params[:q].is_a?(Array) ? params[:q].reverse.join(", ").gsub(/-/, " ") : params[:q]
      query = " #{params[:q]} ".downcase.gsub(/[^a-z]+/,'%')
      logger.info "QUERY: #{query}"
      # @places = Place.find(:all, :conditions => ["name LIKE ? OR long_name LIKE ?", query, query], :limit => 10)
      @places = Place.yahoo_search(params[:q])
    end
    respond_to do |format|
      format.html do
        render_or_redirect_search
      end
      format.js   { render :json => @places.to_json }
    end
  end
  
  def show
    place
  end
  
  def connect
    @place_connection = current_person.person_place_connections.find_or_create_by_place_id(place.id)
    @place_connection.update_attributes(params[:place_connection])
    current_person.send_later :update_place_connection_hierarchy_for, place, params[:place_connection]
    redirect_to place || :back
  end
  
protected

  def place
    @place ||= Place.find_by_woeid(params[:id])
  end

  def find_place
    @place = Place.find_by_woeid(params[:id])
  end

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
