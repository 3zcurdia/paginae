# frozen_string_literal: true

module Paginae
  module SpaceStriper
    refine NilClass do
      def space_strip
        self
      end
    end

    refine String do
      def space_strip
        gsub(/\s+/, " ").strip
      end
    end
  end
end
