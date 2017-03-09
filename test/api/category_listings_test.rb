require "helper"

describe Awis::API::CategoryListings do
  describe "Parsing XML" do
    before do
      Awis.config do |c|
        c.access_key_id = 'key'
        c.secret_access_key = 'secret'
      end

      stub_request(:get, %r{http://awis.amazonaws.com}).to_return(fixture("category_listings/card_games.txt"))
      @category_listings = Awis::Client.new.category_listings(:path => "Top/Games/Card_Games")
    end

    it "Should be has success status code" do
      assert_equal "Success", @category_listings.status_code
    end

    it "Should behas request id" do
      assert_equal "680c43ef-de20-167b-8d12-31c13d6ca0af", @category_listings.request_id
    end

    it "Should be returns recursive count" do
      assert_equal 799, @category_listings.recursive_count
    end

    it "Should be returns count" do
      assert_equal 0, @category_listings.count
    end

    it "Should be returns listings" do
      assert_equal 20, @category_listings.listings.size
    end
  end
end
