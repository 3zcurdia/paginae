# frozen_string_literal: true

module Paginae
  module NodeBuilder
    include Memoizer

    private

    def __define_node(name, **kwargs)
      define_memoized_method("__#{name}_nodes") do |instance|
        instance.document.send(*__node_selector(**kwargs))
      end
      private "__#{name}_nodes"

      define_method("__#{name}_node") do
        send("__#{name}_nodes").first
      end
      private "__#{name}_node"
    end

    def __node_selector(css: nil, xpath: nil, id: nil, **kwargs)
      if css
        [:css, css]
      elsif xpath
        [:xpath, xpath]
      elsif id
        [:xpath, "//*[@id='#{id}']"]
      else
        raise ArgumentError, "Undefined selector type for #{kwargs}"
      end
    end
  end
end
