# frozen_string_literal: true

module Paginae
  module HTMLInitializerInjector
    def self.extended(base)
      base.class_eval do
        def initialize(content)
          @content = content
        end

        def document
          @document ||= Nokogiri::HTML(@content)
        end
      end
    end
  end
end
