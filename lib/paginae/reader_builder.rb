# frozen_string_literal: true

require_relative "reader_builder/array"
require_relative "reader_builder/hash"
require_relative "reader_builder/text"
require_relative "reader_builder/value"

module Paginae
  module ReaderBuilder
    include Memoizer
    include Array
    include Hash
    include Text
    include Value

    private

    def __define_reader(name, mapped: nil, listed: nil, value: nil, **_kwargs)
      if mapped
        __define_hash_reader(name, mapped)
      elsif listed
        __define_list_reader(name, listed)
      elsif value
        __define_value_reader(name, value)
      else
        __define_text_reader(name)
      end
    end
  end
end
