# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def logged_in?
    current_person.present?
  end
  
  def t(str)
    @title = str
  end
  
  def title
    [@title, site_title].compact.join(" -  ")
  end
  
  def site_title
    "MissionsBridge"
  end

end
