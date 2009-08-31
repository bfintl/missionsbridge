# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  helper_method :person_session, :current_person
  
private

  def person_session
    return @person_session if defined?(@person_session)
    @person_session = PersonSession.find
  end

  def current_person
    return @current_person if defined?(@current_person)
    @current_person = person_session && person_session.person
  end
  
  def login_required
    redirect_to login_path if current_person.blank?
  end
  
  def require_no_person
    redirect_to :back unless current_person.blank?
  end
  
  def require_person
    redirect_to login_path if current_person.blank?
  end

end
