# frozen_string_literal: true

require_relative './api/base'
require_relative './api/url_info'
require_relative './api/traffic_history'
require_relative './api/sites_linking_in'
require_relative './api/category_listings'
require_relative './api/category_browse'

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
