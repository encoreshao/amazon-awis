module Awis
  class Client
    def initialize
      raise CertificateError.new("Amazon access certificate is missing!") if Awis.config.access_key_id.nil? || Awis.config.secret_access_key.nil?
    end

    def url_info(args)
      parse_response_with_request("UrlInfo", args)
    end

    def traffic_history(args)
      parse_response_with_request("TrafficHistory", args)
    end

    def sites_linking_in(args)
      parse_response_with_request("SitesLinkingIn", args)
    end

    def category_browse(args)
      parse_response_with_request("CategoryBrowse", args)
    end

    def category_listings(args)
      parse_response_with_request("CategoryListings", args)
    end

    private
    def parse_response_with_request(kclass, args)
      case kclass
      when 'UrlInfo'
        Awis::Models::UrlInfo.new Awis::API::UrlInfo.new.fetch(args)
      when 'SitesLinkingIn'
        Awis::Models::SitesLinkingIn.new Awis::API::SitesLinkingIn.new.fetch(args)
      when 'TrafficHistory'
        Awis::Models::TrafficHistory.new Awis::API::TrafficHistory.new.fetch(args)
      when 'CategoryBrowse'
        Awis::Models::CategoryBrowse.new Awis::API::CategoryBrowse.new.fetch(args)
      when 'CategoryListings'
        Awis::Models::CategoryListings.new Awis::API::CategoryListings.new.fetch(args)
      end
    end
  end
end
