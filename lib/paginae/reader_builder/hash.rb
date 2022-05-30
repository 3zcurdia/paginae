# frozen_string_literal: true

module Paginae
  module ReaderBuilder
    module Hash
      private

      def __define_hash_reader(name, method)
        define_memoized_method name do |instance|
          instance.send("__#{name}_nodes")&.to_h do |node|
            case method
            when Symbol
              instance.send(method, node)
            when Proc
              method.call(node)
            else
              raise ArgumentError, "Invalid mapped type for #{method.class}"
            end
          end&.compact
        end
      end
    end
  end
end
