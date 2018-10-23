# frozen_string_literal: true

module Awis
  module Models
    class UrlInfo < Base
      attr_accessor :data_url, :rank, :asin, :contact_info, :content_data, :usage_statistics, :related_links,
                    :categories, :xml, :contributing_subdomains, :rank_by_country

      def initialize(response)
        @usage_statistics = []
        @related_links = []
        @categories = []
        @contributing_subdomains = []
        @rank_by_country = []

        setup_data! loading_response(response)
      end

      def setup_data!(response)
        @xml = response
        content_data = {
          owned_domains: []
        }
        contact_info = {
          phone_numbers: []
        }
        statistics = []
        related_related_links = []
        category_data = []
        rank_by_country = []
        contributing_subdomains = []


        response.each_node do |node, path|
          text = node.inner_xml
          text = text.nil? || text.empty? ? nil : text.to_i if text.nil? || text.empty? ? nil : text.to_i.to_s == text && node.name != 'aws:Delta'
          text = nil if text.class == String && text.empty?

          if node.name == 'aws:RequestId'
            @request_id ||= text
          elsif node.name == 'aws:StatusCode'
            @status_code ||= text
          elsif node.name == 'aws:DataUrl' && path == "#{traffic_node_name}/aws:DataUrl"
            @data_url = text
          elsif node.name == 'aws:Asin' && path == "#{traffic_node_name}/aws:Asin"
            @asin = text
          elsif node.name == 'aws:Rank' && path == "#{traffic_node_name}/aws:Rank"
            @rank = text
          elsif node.name == 'aws:DataUrl' && path == "#{content_node_name}/aws:DataUrl"
            content_data[:data_url] = text
          elsif node.name == 'aws:Title' && path == "#{content_node_name}/aws:SiteData/aws:Title"
            content_data[:site_title] = text
          elsif node.name == 'aws:Description'
            content_data[:site_description] = text
          elsif node.name == 'aws:MedianLoadTime'
            content_data[:speed_median_load_time] = text
          elsif node.name == 'aws:Percentile'
            content_data[:speed_percentile] = text
          elsif node.name == 'aws:AdultContent'
            content_data[:adult_content] = text
          elsif node.name == 'aws:Locale'
            content_data[:language_locale] = text
          elsif node.name == 'aws:LinksInCount'
            content_data[:links_in_count] = text
          elsif node.name == 'aws:Domain' && path == "#{content_node_name}/aws:OwnedDomains/aws:OwnedDomain/aws:Domain"
            content_data[:owned_domains] << { domain: text }
          elsif node.name == 'aws:Title' && path == "#{content_node_name}/aws:OwnedDomains/aws:OwnedDomain/aws:Title"
            content_data[:owned_domains] << { title: text }
          elsif node.name == 'aws:OnlineSince'
            content_data[:online_since] = text
          elsif node.name == 'aws:DataUrl' && path == "#{root_node_name}/aws:ContactInfo/aws:DataUrl"
            contact_info[:data_url] = text
          elsif node.name == 'aws:OwnerName'
            contact_info[:owner_name] = text
          elsif node.name == 'aws:Email'
            contact_info[:email] = text
          elsif node.name == 'aws:PhysicalAddress'
            contact_info[:physical_address] = text
          elsif node.name == 'aws:CompanyStockTicker'
            contact_info[:company_stock_ticker] = text
          elsif node.name == 'aws:PhoneNumber'
            contact_info[:phone_numbers] << text
          elsif node.name == 'aws:DataUrl' && path == "#{related_links_node_name}/aws:DataUrl"
            related_related_links << { data_url: text }
          elsif node.name == 'aws:NavigableUrl' && path == "#{related_links_node_name}/aws:NavigableUrl"
            related_related_links << { navigable_url: text }
          elsif node.name == 'aws:Title' && path == "#{related_links_node_name}/aws:Title"
            related_related_links << { title: text }
          elsif node.name == 'aws:Title' && path == "#{categories_node_name}/aws:Title"
            category_data << { title: text }
          elsif node.name == 'aws:AbsolutePath' &&  path == "#{categories_node_name}/aws:AbsolutePath"
            category_data << { absolute_path: text }
          elsif node.name == 'aws:Months' && path == "#{statistic_node_name}/aws:TimeRange/aws:Months"
            statistics << { time_range_months: text.nil? || text.empty? ? nil : text.to_i }
          elsif node.name == 'aws:Days' && path == "#{statistic_node_name}/aws:TimeRange/aws:Days"
            statistics << { time_range_days: text.nil? || text.empty? ? nil : text.to_i }
          elsif node.name == 'aws:Value' && path == "#{statistic_node_name}/aws:Rank/aws:Value"
            statistics << { rank_value: text.nil? || text.empty? ? nil : text.to_i }
          elsif node.name == 'aws:Delta' && path == "#{statistic_node_name}/aws:Rank/aws:Delta"
            statistics << { rank_delta: text.nil? || text.empty? ? nil : text.to_f }
          elsif node.name == 'aws:Value' && path == "#{statistic_node_name}/aws:Reach/aws:Rank/aws:Value"
            statistics << { reach_rank_value: text.nil? || text.empty? ? nil : text.to_i }
          elsif node.name == 'aws:Delta' && path == "#{statistic_node_name}/aws:Reach/aws:Rank/aws:Delta"
            statistics << { reach_rank_delta: text.nil? || text.empty? ? nil : text.to_f }
          elsif node.name == 'aws:Value' && path == "#{statistic_node_name}/aws:Reach/aws:PerMillion/aws:Value"
            statistics << { reach_per_million_value: text.nil? || text.empty? ? nil : text.to_f }
          elsif node.name == 'aws:Delta' && path == "#{statistic_node_name}/aws:Reach/aws:PerMillion/aws:Delta"
            statistics << { reach_per_million_delta: text.nil? || text.empty? ? nil : text.to_f }
          elsif node.name == 'aws:Value' && path == "#{statistic_node_name}/aws:PageViews/aws:PerMillion/aws:Value"
            statistics << { page_views_per_million_value: text.nil? || text.empty? ? nil : text.to_f }
          elsif node.name == 'aws:Delta' && path == "#{statistic_node_name}/aws:PageViews/aws:PerMillion/aws:Delta"
            statistics << { page_views_per_million_delta: text.nil? || text.empty? ? nil : text.to_f }
          elsif node.name == 'aws:Value' && path == "#{statistic_node_name}/aws:PageViews/aws:Rank/aws:Value"
            statistics << { page_views_rank_value: text.nil? || text.empty? ? nil : text.to_i }
          elsif node.name == 'aws:Delta' && path == "#{statistic_node_name}/aws:PageViews/aws:Rank/aws:Delta"
            statistics << { page_views_rank_delta: text.nil? || text.empty? ? nil : text.to_f }
          elsif node.name == 'aws:Value' && path == "#{statistic_node_name}/aws:PageViews/aws:PerUser/aws:Value"
            statistics << { page_views_per_user_value: text.nil? || text.empty? ? nil : text.to_f }
          elsif node.name == 'aws:Delta' && path == "#{statistic_node_name}/aws:PageViews/aws:PerUser/aws:Delta"
            statistics << { page_views_per_user_delta: text.nil? || text.empty? ? nil : text.to_f }
          elsif node.name == 'aws:Country' && path == rank_by_country_node_name
            rank_by_country << { country_code: node.attributes['Code'] }
          elsif node.name == 'aws:Rank' && path == "#{rank_by_country_node_name}/aws:Rank"
            rank_by_country << { rank: text.nil? || text.empty? ? nil : text.to_i }
          elsif node.name == 'aws:PageViews' && path == "#{rank_by_country_node_name}/aws:Contribution/aws:PageViews"
            rank_by_country << { contribution_page_views: text.nil? || text.empty? ? nil : text.to_f }
          elsif node.name == 'aws:Users' && path == "#{rank_by_country_node_name}/aws:Contribution/aws:Users"
            rank_by_country << { contribution_users: text.nil? || text.empty? ? nil : text.to_f }
          elsif node.name == 'aws:DataUrl' && path == "#{contributing_subdomains_node_name}/aws:DataUrl"
            contributing_subdomains << { data_url: text }
          elsif node.name == 'aws:Months' && path == "#{contributing_subdomains_node_name}/aws:TimeRange/aws:Months"
            contributing_subdomains << { time_range_months: text.nil? || text.empty? ? nil : text.to_i }
          elsif node.name == 'aws:Percentage' && path == "#{contributing_subdomains_node_name}/aws:Reach/aws:Percentage"
            contributing_subdomains << { reach_percentage: text.nil? || text.empty? ? nil : text.to_f }
          elsif node.name == 'aws:Percentage' && path == "#{contributing_subdomains_node_name}/aws:PageViews/aws:Percentage"
            contributing_subdomains << { page_views_percentage: text.nil? || text.empty? ? nil : text.to_f }
          elsif node.name == 'aws:PerUser' && path == "#{contributing_subdomains_node_name}/aws:PageViews/aws:PerUser"
            contributing_subdomains << { page_views_per_user: text.nil? || text.empty? ? nil : text.to_f }
          end
        end

        init_entity_data('content_data', content_data, ContentData)
        init_entity_data('contact_info', contact_info, ContactInfo)

        relationship_collections(@usage_statistics, statistics, 13, UsageStatistic)
        relationship_collections(@related_links, related_related_links, 3, RelatedLink)
        relationship_collections(@categories, category_data, 3, CategoryData)
        relationship_collections(@rank_by_country, rank_by_country, 4, RankByCountry)
        relationship_collections(@contributing_subdomains, contributing_subdomains, 5, ContributingSubdomain)
      end

      def is_404?
        success? && rank == 404
      end

      def init_entity_data(attr_name, data, kclass)
        return if data.empty?

        instance_variable_set("@#{attr_name}", kclass.new(data))
      end

      def content_node_name
        "#{root_node_name}/aws:ContentData"
      end

      def related_node_name
        "#{root_node_name}/aws:Related"
      end

      def related_links_node_name
        "#{related_node_name}/aws:RelatedLinks/aws:RelatedLink"
      end

      def categories_node_name
        "#{related_node_name}/aws:Categories/aws:CategoryData"
      end

      def traffic_node_name
        "#{root_node_name}/aws:TrafficData"
      end

      def statistic_node_name
        "#{traffic_node_name}/aws:UsageStatistics/aws:UsageStatistic"
      end

      def contributing_subdomains_node_name
        "#{traffic_node_name}/aws:ContributingSubdomains/aws:ContributingSubdomain"
      end

      def rank_by_country_node_name
        "#{traffic_node_name}/aws:RankByCountry/aws:Country"
      end

      def has_data?
        !@rank.nil?
      end

      def geos_sorted
        rank_by_country.select{|rbc| !rbc.rank.nil? }.
                        sort_by{|rbc| - rbc.contribution_page_views.round }.
                        map{|rbc| { rbc.country_code => rbc.contribution_page_views.round } }
      end

      def geos_hash
        @geos_hash ||= geos_sorted.reduce({}, :merge)
      end

      def domains
        content_data.owned_domains.map(&:domain)
      end

      def contributing_hostnames
        contributing_subdomains.map(&:data_url).reject{ |hostname| hostname == 'OTHER' }
      end

      def pvs_per_user
        usage_statistics.first.page_views_per_user_value
      end

      def pvs_rank
        usage_statistics.first.page_views_rank_value
      end

      def get_pvs_per_mil
        usage_statistics.first.page_views_per_million_value
      end

      def speed_percentile
        content_data.speed_percentile
      end

      def get_median_load_time
        content_data.speed_median_load_time
      end

      def daily_GDN_page_views
        if rank
          alexa_gdn.each do |max_pvs, gdn_range|
            return gdn_range if rank > max_pvs
          end
        end
      end

      def speed_rating
        if get_median_load_time
          alexa_speed_rating.each do |max_load_time, rating|
            return rating if get_median_load_time > max_load_time
          end
        end
        return 'AVERAGE ( < 5s)'
      end

      def alexa_speed_rating
        {
          2200 => 'POOR ( > 5s)',
          1200 => 'AVERAGE ( < 5s)',
          0 => 'GOOD ( < 3s)'
        }
      end

      def rank_page_view
        {
          20000 => '< 1K',
          5000 => '1K - 10K',
          3000 => '10K - 100K',
          1900 => '100K - 500K',
          1300 => '500K - 1M',
          850 => '2M - 5M',
          550 => '5M - 10M',
          350 => '10M - 20M',
          200 => '20M - 50M',
          100 => '50M - 100M',
          28 => '100M+',
        }
      end

      def alexa_gdn
        {
          250000 => '< 1K',
          100000 => '1K - 10K',
           50000 => '10K - 100K',
           20000 => '100K - 500K',
           10000 => '500K - 1M',
            5000 => '1M - 2M',
            2000 => '2M - 5M',
            1000 => '5M - 10M',
             500 => '10M - 20M',
             150 => '20M - 50M',
              30 => '50M - 100M',
               0 => '100M+'
        }
      end
    end

    class ContentData < BaseEntity
      attr_accessor :data_url, :site_title, :site_description, :online_since, :speed_median_load_time, :speed_percentile, :adult_content,
                    :language_locale, :links_in_count, :owned_domains

      def initialize(options)
        @owned_domains = []
        owned_domain_objects = options.delete(:owned_domains)
        super(options)
        owned_domains_relationship_collections(@owned_domains, owned_domain_objects, 2, OwnedDomain)
      end

      def owned_domains_relationship_collections(item_object, items, items_count, kclass)
        return if items.empty?

        all_items = {}.array_slice_merge!(:item, items, items_count)
        all_items.map { |item| item_object << kclass.new(item) }
      end
    end

    class OwnedDomain < BaseEntity
      attr_accessor :domain, :title
    end

    class ContactInfo < BaseEntity
      attr_accessor :data_url, :owner_name, :email, :physical_address, :company_stock_ticker, :phone_numbers

      def initialize(options)
        phone_numbers = options.delete(:phone_numbers)
        super(options)
        phone_number_collections(phone_numbers)
      end

      def phone_number_collections(phone_numbers)
        return @phone_numbers = [] if phone_numbers.nil? || phone_numbers.empty?

        phone_numbers.map { |item| @phone_numbers << PhoneNumber.new(item) }
      end
    end

    class PhoneNumber < BaseEntity
      attr_accessor :number
    end

    class RelatedLink < BaseEntity
      attr_accessor :data_url, :navigable_url, :title
    end

    class CategoryData < BaseEntity
      attr_accessor :title, :absolute_path
    end

    class UsageStatistic < BaseEntity
      attr_accessor :time_range_months, :time_range_days, :rank_value, :rank_delta,
                    :reach_rank_value, :reach_rank_delta,
                    :reach_per_million_value, :reach_per_million_delta,
                    :page_views_per_million_value, :page_views_per_million_delta,
                    :page_views_rank_value, :page_views_rank_delta,
                    :page_views_per_user_value, :page_views_per_user_delta

      def range_type
        return 'month' unless time_range_months.nil? || time_range_months.empty?

        'day'
      end

      def range_count
        (time_range_months || time_range_days)
      end
    end

    class ContributingSubdomain < BaseEntity
      attr_accessor :data_url, :time_range_months, :reach_percentage, :page_views_percentage, :page_views_per_user
    end

    class RankByCountry < BaseEntity
      attr_accessor :country_code, :rank, :contribution_page_views, :contribution_users
    end
  end
end