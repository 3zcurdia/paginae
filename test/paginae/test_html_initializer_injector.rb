# frozen_string_literal: true

require "test_helper"

module Paginae
  class TestHtmlInitializerInjector < Minitest::Test
    class PageObjectMock
      extend Paginae::HTMLInitializerInjector
    end

    def content
      "<html><head></head><body><h1>Hello World</h1></body></html>"
    end

    def test_initialize_method_without_args
      assert_raises ArgumentError do
        PageObjectMock.new
      end
    end

    def test_initialize_document
      page = PageObjectMock.new(content)
      assert_kind_of Nokogiri::HTML::Document, page.document
    end
  end
end
