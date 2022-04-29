# frozen_string_literal: true

module Paginae
  module AttributeInjector
    def self.extended(base)
      class << base
        def attribute(name, **kwargs)
          __define_node(name, **kwargs)
          __define_reader(name, **kwargs)
        end

        private

        def __define_node(name, **kwargs)
          selector = __node_selector(**kwargs)
          define_method("__#{name}_node") do
            instance_variable_get("@#{name}_node") || instance_variable_set("@#{name}_node", document.send(*selector)&.compact)
          end
          private "__#{name}_node"
        end

        def __node_selector(**kwargs)
          if kwargs.key?(:css)
            kwargs.slice(:css).to_a.flatten
          elsif kargs.key?(:xpath)
            kwargs.slice(:xpath).to_a.flatten
          elsif kargs.key?(:id)
            [:xpath, "//*[@id='#{kwargs[:id]}']"]
          else
            raise ArgumentError, "Undefined selector type"
          end
        end

        def __define_reader(name, **kwargs)
          if kwargs.key?(:maped)
            __define_map_reader(name, **kwargs)
          elsif kwargs.key?(:listed)
            __define_list_reader(name, **kwargs)
          else
            __define_text_reader(name)
          end
        end

        def __define_map_reader(name, **kwargs)
          mapper = __mapper_proc(kwargs[:maped])
          define_method name do
            return instance_variable_get("@#{name}") if instance_variable_defined?("@#{name}")

            map = send("__#{name}_node")&.to_h do |node|
              mapper.call(node)
            end
            instance_variable_set("@#{name}", map)
          end
        end

        def __mapper_proc(mapper)
          case mapper
          when Symbol
            ->(node) { send(mapper, node) }
          when Proc
            mapper
          else
            raise ArgumentError, "Invalid maped type"
          end
        end

        def __define_list_reader(name, **kwargs)
          mapper = __lister_proc(kwargs[:listed])
          define_method name do
            return instance_variable_get("@#{name}") if instance_variable_defined?("@#{name}")

            list = send("__#{name}_node")&.map do |node|
              mapper.call(node)
            end
            instance_variable_set("@#{name}", list)
          end
        end

        def __lister_proc(lister)
          case lister
          when TrueClass
            ->(node) { node.text }
          when Symbol
            ->(node) { send(lister, node) }
          when Proc
            lister
          else
            raise ArgumentError, "Invalid listed type"
          end
        end

        def __define_text_reader(name)
          define_method name do
            send("__#{name}_node").text&.gsub(/\s+/, " ")&.strip
          end
        end
      end
    end
  end
end
