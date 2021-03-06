require 'yaml'
if RAILS_ENV == "production"
  YAHOO = {}
  YAHOO['appid'] = ENV["YAHOO_APPID"]
else
  begin
    YAHOO = YAML.load_file("#{RAILS_ROOT}/config/yahoo.yml")
    raise if YAHOO['appid'] == nil
  rescue
    puts "Couldn't find a Yahoo! Application ID in config/yahoo.yml. See config/yahoo.yml.example"
    exit
  end  
end
