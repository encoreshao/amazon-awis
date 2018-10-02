# frozen_string_literal: true

module Awis
  module API
    autoload :Base,             'awis/api/base'
    autoload :UrlInfo,          'awis/api/url_info'
    autoload :TrafficHistory,   'awis/api/traffic_history'
    autoload :SitesLinkingIn,   'awis/api/sites_linking_in'
    autoload :CategoryListings, 'awis/api/category_listings'
    autoload :CategoryBrowse,   'awis/api/category_browse'
  end
end
