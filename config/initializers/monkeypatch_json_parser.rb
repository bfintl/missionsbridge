module ActiveSupport
  module JSON
    def self.decode(json)
      ::JSON.parse(json)
    end
  end
end
