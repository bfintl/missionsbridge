ActionController::Routing::Routes.draw do |map|

  ###
  # Core resources
  ##
  
  # Places
  map.resources :places,
    :collection => { :search => [:get,:post] },
    :member => { :connect => :post } do |place|
    place.resources :flickr_photos
  end
  
  # Flickr photos
  map.resources :flickr_photos

  # Extra stuff for searching and showing places
  map.connect '/places/*permalink/:id', :controller => 'places', :action => 'show', :id => /[0-9]+/
  map.connect '/places/*q', :controller => 'places', :action => 'search'

  # Show places#index for the root
  map.root :controller => 'places', :action => 'index'

  ###
  # Authentication
  ##
  
  map.resources :people
  map.resource :session
  
  # map.activate  '/activate/:activation_code', :controller => 'accounts', :action => 'activate', :activation_code => nil
  map.signup    '/signup',  :controller => 'people', :action => 'new'
  map.login     '/login',   :controller => 'sessions', :action => 'new'
  map.logout    '/logout',  :controller => 'sessions', :action => 'destroy'
  # map.resources :accounts, :sessions

end
