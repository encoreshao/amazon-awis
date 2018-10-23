# frozen_string_literal: true

module Awis
  module Utils
    class XML
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def each_node(attributes_in_path = false)
        reader = Nokogiri::XML::Reader(@data)
        nodes = ['']

        reader.each do |node|
          if node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
            if attributes_in_path && !node.attributes.empty?
              attributes = []

              node.attributes.sort.each do |name, value|
                attributes << "@#{name}=#{value}"
              end
              nodes << "#{node.name}/#{attributes.join('/')}"
            else
              nodes << node.name
            end
            path = nodes.join('/')

            yield node, path
          end

          nodes.pop if node.node_type == Nokogiri::XML::Reader::TYPE_END_ELEMENT || node.self_closing? # End tag
        end
      end
    end
  end
end
