# frozen_string_literal: true

module Paginae
  module AttributeInjector
    def self.extended(base)
      class << base
        include NodeBuilder
        include ReaderBuilder

        def attribute(name, **kwargs)
          __define_node(name, **kwargs)
          __define_reader(name, **kwargs)
          instance_variable_set("@paginae_attributes", Set.new) unless instance_variable_defined?("@paginae_attributes")
          instance_variable_get("@paginae_attributes").add(name.to_sym)
        end

        attr_reader :paginae_attributes
      end

      base.class_eval do
        def data
          self.class.paginae_attributes.to_h { |key| [key, send(key)] }
        end
      end
    end
  end
end
