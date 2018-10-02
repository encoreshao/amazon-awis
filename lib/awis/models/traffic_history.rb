# frozen_string_literal: true

module Awis
  module Models
    class TrafficHistory < Base
      attr_accessor :range, :site, :start, :historical_data

      def initialize(response)
        @historical_data = []
        setup_data! loading_response(response)
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      def setup_data!(response)
        datas = []

        response.each_node do |node, path|
          text = node.inner_xml
          text = text.to_i if text.to_i.to_s == text
          text = nil if text.class == String && text.empty?

          if node.name == 'aws:RequestId'
            @request_id ||= text
          elsif node.name == 'aws:StatusCode'
            @status_code ||= text
          elsif node.name == 'aws:Range'
            @range ||= text
          elsif node.name == 'aws:Site'
            @site ||= text
          elsif node.name == 'aws:Start'
            @start ||= text
          elsif node.name == 'aws:Date' && path == "#{base_node_name}/aws:Date"
            datas << { date: text }
          elsif node.name == 'aws:PerMillion' && path == "#{base_node_name}/aws:PageViews/aws:PerMillion"
            datas << { page_views_per_million: text }
          elsif node.name == 'aws:PerUser' && path == "#{base_node_name}/aws:PageViews/aws:PerUser"
            datas << { page_views_per_user: text }
          elsif node.name == 'aws:Rank' && path == "#{base_node_name}/aws:Rank"
            datas << { rank: text }
          elsif node.name == 'aws:PerMillion' && path == "#{base_node_name}/aws:Reach/aws:PerMillion"
            datas << { reach_per_million: text }
          end
        end

        relationship_collections(@historical_data, datas, 5, HistoricalData)
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity

      def base_node_name
        "#{root_node_name}/aws:TrafficHistory/aws:HistoricalData/aws:Data"
      end
    end

    class HistoricalData < BaseEntity
      attr_accessor :date, :page_views_per_million, :page_views_per_user, :rank, :reach_per_million
    end
  end
end
