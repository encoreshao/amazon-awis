# frozen_string_literal: true

require 'helper'

describe Awis::API::UrlInfo do
  before do
    Awis.config do |c|
      c.access_key_id = 'key'
      c.secret_access_key = 'secret'
    end
  end

  it 'Allows to pass single attribute as response_group' do
    stub_request(:get, api_url).to_return(body: 'ok')

    @url_info = Awis::API::UrlInfo.new
    @url_info.fetch(url: 'github.com', response_group: 'rank')
    assert_equal ['rank'], @url_info.arguments[:response_group]
  end

  describe 'Parsing XML returned by options rank, links_in_count, site_data' do
    before do
      stub_request(:get, api_url).to_return(fixture('url_info/custom-response-group.txt'))

      @url_info = Awis::Client.new.url_info(url: 'github.com', response_group: %w[rank links_in_count site_data])
    end

    it 'Should be return attribute request ID' do
      assert_equal '2bc0f070-540f-8fbf-6804-cd6c9241a039', @url_info.request_id
    end

    it 'Should be return attribute rank' do
      assert_equal 493, @url_info.rank
    end

    it 'Should be return attribute data url' do
      assert_equal 'github.com/', @url_info.content_data.data_url
    end

    it 'Should be return attribute site title' do
      assert_equal 'GitHub', @url_info.content_data.site_title
    end

    it 'Should be return attribute site description' do
      expected = 'Online project hosting using Git. Includes source-code browser, in-line editing, wikis, and ticketing. Free for public open-source code. Commercial closed source hosting is also available.'

      assert_equal expected, @url_info.content_data.site_description
    end
  end

  describe 'with github.com full response group' do
    before do
      stub_request(:get, api_url).to_return(fixture('url_info/github_full.txt'))
      @url_info = Awis::Client.new.url_info(url: 'github.com')
    end

    it 'Should be has request id' do
      assert_equal '2df424ef-f1fe-5452-c372-ea598784dbd7', @url_info.request_id
    end

    it 'Should be has success status code' do
      assert_equal 'Success', @url_info.status_code
    end

    it 'Should be return success' do
      assert_equal true, @url_info.success?
    end

    it 'Should be return attribute rank' do
      assert_equal 69, @url_info.rank
    end

    it 'Should be return attribute data url' do
      assert_equal 'github.com', @url_info.content_data.data_url
    end

    it 'Should be return attribute site title' do
      assert_equal 'GitHub', @url_info.content_data.site_title
    end

    it 'Should be return attribute site description' do
      expected = 'GitHub is the best place to share code with friends, co-workers, classmates, and complete strangers. Over four million people use GitHub to build amazing things together.'
      assert_equal expected, @url_info.content_data.site_description
    end

    it 'Should be return attribute links in count' do
      assert_equal 72_886, @url_info.content_data.links_in_count
    end

    it 'Should be return attribute speed_median load time' do
      assert_equal 1672, @url_info.content_data.speed_median_load_time
    end

    it 'Should be return attribute speed percentile' do
      assert_equal 52, @url_info.content_data.speed_percentile
    end

    it 'Should be return attribute related links' do
      assert_equal 10, @url_info.related_links.size
    end

    it 'Should be return attribute categories' do
      assert_equal 2, @url_info.categories.size
    end

    it 'Should be return attribute usage statistics' do
      assert_equal 4, @url_info.usage_statistics.size
    end
  end

  describe 'with github.com rank response group' do
    before do
      stub_request(:get, api_url).to_return(fixture('url_info/github_rank.txt'))
      @url_info = Awis::Client.new.url_info(url: 'github.com', response_group: ['rank'])
    end

    it 'Should be has request id' do
      assert_equal '2df424ef-f1fe-5452-c372-ea598784dbd7', @url_info.request_id
    end

    it 'Should be return attribute rank' do
      assert_equal 69, @url_info.rank
    end
  end
end
