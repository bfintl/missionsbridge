module PlacesHelper
  
  def jquery_ready(js="")
    javascript_tag "$().ready(function(){#{js}});"
  end
  
end
