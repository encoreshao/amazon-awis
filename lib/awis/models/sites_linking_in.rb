# frozen_string_literal: true

module Awis
  module Models
    class SitesLinkingIn < Base
      attr_accessor :sites

      def initialize(response)
        @sites = []

        super(response)
      end

      def setup_data!(response)
        sites = []

        response.each_node do |node, _path|
          text = node.inner_xml
          text = nil if text.class == String && text.empty?

          if node.name == 'aws:RequestId'
            @request_id ||= text
          elsif node.name == 'aws:StatusCode'
            @status_code ||= text
          elsif node.name == 'aws:Title'
            sites << { title: text }
          elsif node.name == 'aws:Url'
            sites << { url: text }
          end
        end

        relationship_collections(@sites, sites, 2, Site)
      end
    end

    class Site < BaseEntity
      attr_accessor :title, :url
    end
  end
end
