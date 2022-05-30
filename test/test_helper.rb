# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "paginae"
require "debug"

require "minitest/autorun"

module Minitest
  class Test
    using Paginae::SpaceStriper
  end
end
