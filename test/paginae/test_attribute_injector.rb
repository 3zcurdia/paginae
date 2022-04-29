# frozen_string_literal: true

require "test_helper"

module Paginae
  class TestAttributeInjector < Minitest::Test
    class MockPageCss
      extend Paginae::AttributeInjector

      attribute :title, css: ".title"

      def document
        Nokogiri::HTML("<html><head></head><body><h1 class='title'>Hello World</h1></body></html>")
      end
    end

    class MockPageXpath
      extend Paginae::AttributeInjector

      attribute :title, xpath: "//h1"

      def document
        Nokogiri::HTML("<html><head></head><body><h1>Hello World</h1></body></html>")
      end
    end

    class MockPageID
      extend Paginae::AttributeInjector

      attribute :title, id: "mainTitle"

      def document
        Nokogiri::HTML("<html><head></head><body><h1 id=\"mainTitle\">Hello World</h1></body></html>")
      end
    end

    class MockPageList
      extend Paginae::AttributeInjector

      attribute :some_list, css: ".a-list li", listed: true

      def document
        Nokogiri::HTML("<html><head></head><body><ul class=\"a-list\"><li>A</li><li>B</li><li>C</li><ul></body></html>")
      end
    end

    class MockPageListProc
      extend Paginae::AttributeInjector

      attribute :some_list, css: ".a-list li", listed: ->(node) { node.text }

      def document
        Nokogiri::HTML("<html><head></head><body><ul class=\"a-list\"><li>A</li><li>B</li><li>C</li><ul></body></html>")
      end
    end

    class MockPageListMethod
      extend Paginae::AttributeInjector

      attribute :some_list, css: ".a-list li", listed: :to_list

      def document
        Nokogiri::HTML("<html><head></head><body><ul class=\"a-list\"><li>A</li><li>B</li><li>C</li><ul></body></html>")
      end

      def to_list(node)
        node.text
      end
    end

    class MockPageMap
      extend Paginae::AttributeInjector

      attribute :some_map, css: ".items a", mapped: ->(node) { [node.text, node["href"]] }

      # rubocop:disable Layout/LineLength
      def document
        Nokogiri::HTML("<html><head></head><body><ul class=\"items\"><a href=\"#1\">a</a><a href=\"#2\">b</a><a href=\"#3\">c</a><ul></body></html>")
      end
      # rubocop:enable Layout/LineLength
    end

    class MockPageMapMethod
      extend Paginae::AttributeInjector

      attribute :some_map, css: ".items a", mapped: :to_map

      # rubocop:disable Layout/LineLength
      def document
        Nokogiri::HTML("<html><head></head><body><ul class=\"items\"><a href=\"#1\">a</a><a href=\"#2\">b</a><a href=\"#3\">c</a><ul></body></html>")
      end
      # rubocop:enable Layout/LineLength

      def to_map(node)
        [node.text, node["href"]]
      end
    end

    def test_css_selector_css_attribute
      page = MockPageCss.new
      assert_equal "Hello World", page.title
    end

    def test_css_selector_xpath_attribute
      page = MockPageXpath.new
      assert_equal "Hello World", page.title
    end

    def test_css_selector_id_attribute
      page = MockPageID.new
      assert_equal "Hello World", page.title
    end

    def test_css_selector_list_attribute
      page = MockPageList.new
      assert_equal %w[A B C], page.some_list
    end

    def test_css_selector_list_proc_attribute
      page = MockPageListProc.new
      assert_equal %w[A B C], page.some_list
    end

    def test_css_selector_list_method_attribute
      page = MockPageListMethod.new
      assert_equal %w[A B C], page.some_list
    end

    def test_css_selector_map_attribute
      page = MockPageMap.new
      expected = { "a" => "#1", "b" => "#2", "c" => "#3" }
      assert_equal expected, page.some_map
    end

    def test_css_selector_map_method_attribute
      page = MockPageMapMethod.new
      expected = { "a" => "#1", "b" => "#2", "c" => "#3" }
      assert_equal expected, page.some_map
    end
  end
end
