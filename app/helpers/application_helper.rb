# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def logged_in?
    current_person.present?
  end

end
