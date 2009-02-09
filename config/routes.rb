ActionController::Routing::Routes.draw do |map|

  ###
  # Core resources
  ##
  map.resources :places, :collection => { :search => [:get,:post] }
  map.connect '/places/*permalink', :controller => 'places', :action => 'show'

  ###
  # Authentication
  ##
  map.activate  '/activate/:activation_code', :controller => 'accounts', :action => 'activate', :activation_code => nil
  map.signup    '/signup',  :controller => 'accounts', :action => 'new'
  map.login     '/login',   :controller => 'sessions', :action => 'new'
  map.logout    '/logout',  :controller => 'sessions', :action => 'destroy'
  map.resources :accounts, :sessions

end
