# frozen_string_literal: true

module Paginae
  module ReaderBuilder
    module Value
      using SpaceStriper

      private

      def __define_value_reader(name, value)
        define_memoized_method name do |instance|
          instance
            .send("__#{name}_node")
            &.attribute(value.to_s)
            &.value
            &.space_strip
        end
      end
    end
  end
end
