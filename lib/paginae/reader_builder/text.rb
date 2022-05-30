# frozen_string_literal: true

module Paginae
  module ReaderBuilder
    module Text
      using SpaceStriper

      private

      def __define_text_reader(name)
        define_memoized_method name do |instance|
          instance
            .send("__#{name}_node")
            &.text
            &.space_strip
        end
      end
    end
  end
end
