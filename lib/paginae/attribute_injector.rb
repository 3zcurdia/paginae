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
          define_method("__#{name}_nodes") do
            instance_variable_get("@#{name}_nodes") || instance_variable_set("@#{name}_node", document.send(*selector))
          end
          private "__#{name}_nodes"

          define_method("__#{name}_node") do
            send("__#{name}_nodes").first
          end
          private "__#{name}_node"
        end

        def __node_selector(**kwargs)
          if kwargs.key?(:css)
            kwargs.slice(:css).to_a.flatten
          elsif kwargs.key?(:xpath)
            kwargs.slice(:xpath).to_a.flatten
          elsif kwargs.key?(:id)
            [:xpath, "//*[@id='#{kwargs[:id]}']"]
          else
            raise ArgumentError, "Undefined selector type"
          end
        end

        def __define_reader(name, **kwargs)
          if kwargs.key?(:mapped)
            __define_map_reader(name, **kwargs)
          elsif kwargs.key?(:listed)
            __define_list_reader(name, **kwargs)
          else
            __define_text_reader(name)
          end
        end

        def __define_map_reader(name, **kwargs)
          define_method name do
            return instance_variable_get("@#{name}") if instance_variable_defined?("@#{name}")

            map = send("__#{name}_nodes")&.to_h do |node|
              case kwargs[:mapped]
              when Symbol
                send(kwargs[:mapped], node)
              when Proc
                kwargs[:mapped].call(node)
              else
                raise ArgumentError, "Invalid mapped type"
              end
            end
            instance_variable_set("@#{name}", map&.compact)
          end
        end

        def __define_list_reader(name, **kwargs)
          define_method name do
            return instance_variable_get("@#{name}") if instance_variable_defined?("@#{name}")

            list = send("__#{name}_nodes")&.map do |node|
              case kwargs[:listed]
              when TrueClass
                node.text
              when Symbol
                send(kwargs[:listed], node)
              when Proc
                kwargs[:listed].call(node)
              else
                raise ArgumentError, "Invalid listed type"
              end
            end
            instance_variable_set("@#{name}", list&.compact)
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
