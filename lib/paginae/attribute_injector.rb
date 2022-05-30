# frozen_string_literal: true

module Paginae
  module AttributeInjector
    def self.extended(base)
      base.class_eval do
        def data
          instance_variables
            .reject { |var| var.to_s =~ /_node/ }
            .to_h { |var| [var.to_s.sub("@", "").to_sym, instance_variable_get(var)] }
            .compact
        end
      end

      class << base
        include NodeBuilder
        include ReaderBuilder

        def attribute(name, **kwargs)
          __define_node(name, **kwargs)
          __define_reader(name, **kwargs)
        end
      end
    end
  end
end
