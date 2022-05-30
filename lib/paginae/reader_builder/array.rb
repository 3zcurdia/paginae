# frozen_string_literal: true

module Paginae
  module ReaderBuilder
    module Array
      using SpaceStriper

      private

      def __define_list_reader(name, method)
        define_memoized_method name do |instance|
          instance.send("__#{name}_nodes")&.map do |node|
            case method
            when TrueClass
              node&.text&.space_strip
            when Symbol
              instance.send(method, node)
            when Proc
              method.call(node)
            else
              raise ArgumentError, "Invalid listed type for #{method.class}"
            end
          end&.compact
        end
      end
    end
  end
end
