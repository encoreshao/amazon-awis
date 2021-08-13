# frozen_string_literal: true

module Awis
  class Client
    def initialize
      raise CertificateError, 'Amazon access certificate is missing!' if Awis.config.access_key_id.nil? || Awis.config.secret_access_key.nil?
    end

    def url_info(args)
      parse_response_with_request('UrlInfo', args)
    end

    def traffic_history(args)
      parse_response_with_request('TrafficHistory', args)
    end

    def sites_linking_in(args)
      parse_response_with_request('SitesLinkingIn', args)
    end

    def category_browse(args)
      parse_response_with_request('CategoryBrowse', args)
    end

    def category_listings(args)
      parse_response_with_request('CategoryListings', args)
    end

    private

    def parse_response_with_request(kclass, args)
      raise ArgumentError, 'Amazon class was missing!'  unless [
        'UrlInfo', 'SitesLinkingIn', 'TrafficHistory',
        'CategoryBrowse', 'CategoryListings'
      ].include?(kclass)

      response = Kernel.const_get("Awis::API::#{kclass}").new.fetch(args)
      Kernel.const_get("Awis::Models::#{kclass}").new(response)
    end
  end
end
