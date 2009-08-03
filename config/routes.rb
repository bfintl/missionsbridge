ActionController::Routing::Routes.draw do |map|

  ###
  # Core resources
  ##
  map.resources :places, :collection => { :search => [:get,:post] }
  map.connect '/places/*permalink/:woeid', :controller => 'places', :action => 'show', :woeid => /[0-9]+/
  map.connect '/places/*q', :controller => 'places', :action => 'search'
  map.root :controller => 'places', :action => 'index'

  ###
  # Authentication
  ##
  
  map.resources :people
  map.resource :person_session
  
  # map.activate  '/activate/:activation_code', :controller => 'accounts', :action => 'activate', :activation_code => nil
  # map.signup    '/signup',  :controller => 'accounts', :action => 'new'
  # map.login     '/login',   :controller => 'sessions', :action => 'new'
  # map.logout    '/logout',  :controller => 'sessions', :action => 'destroy'
  # map.resources :accounts, :sessions

end
