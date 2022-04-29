module Paginae
  module Web
    def self.included(base)
      base.extend(HTMLInitializerInjector)
      base.extend(AttributeInjector)
    end
  end
end