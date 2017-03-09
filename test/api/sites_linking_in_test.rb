require "helper"

describe Awis::API::SitesLinkingIn do
  describe "parsing xml" do
    before do
      Awis.config do |c|
        c.access_key_id = 'key'
        c.secret_access_key = 'secret'
      end

      stub_request(:get, %r{http://awis.amazonaws.com}).to_return(fixture("sites_linking_in/github.txt"))
      @sites_linking_in = Awis::Client.new.sites_linking_in(:url => "github.com")
    end

    it "shoudl be has request id" do
      assert_equal "db27009a-4ae7-f195-9340-417a01fa54c6", @sites_linking_in.request_id
    end

    it "shoudl be has success status code" do
      assert_equal "Success", @sites_linking_in.status_code
    end

    it "returns sites" do
      assert_equal 20, @sites_linking_in.sites.size
    end

    it "shoudl be has Title attribute on single site" do
      assert_equal "youtube.com", @sites_linking_in.sites[0].title
    end

    it "shoudl be has Url attribute on single site" do
      assert_equal "youtube.com:80/yt/dev/api-resources.html", @sites_linking_in.sites[0].url
    end
  end
end
