class Hash
  
  # Make a copy of the hash with all keys underscored
  def underscore_keys
    returning Hash.new do |h|
      self.keys.each do |key|
        h[key.underscore.gsub(/ /,'_')] = self[key].is_a?(Hash) ? self[key].underscore_keys : self[key]
      end
    end
  end
end