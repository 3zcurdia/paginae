# frozen_string_literal: true

require "nokogiri"
require_relative "paginae/version"
require_relative "paginae/html_initializer_injector"
require_relative "paginae/attribute_injector"
require_relative "paginae/web"

module Paginae
  class Error < StandardError; end
end
