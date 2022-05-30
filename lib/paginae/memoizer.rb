# frozen_string_literal: true

module Paginae
  module Memoizer
    def define_memoized_method(name)
      define_method name do
        return instance_variable_get("@#{name}") if instance_variable_defined?("@#{name}")

        instance_variable_set("@#{name}", yield(self))
      end
    end
  end
end
