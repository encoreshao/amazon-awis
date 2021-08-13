# frozen_string_literal: true
require 'pry'
require_relative './../helper'

describe Awis::API::UrlInfo do
  before do
    Awis.config do |c|
      c.access_key_id = 'key'
      c.secret_access_key = 'secret'
    end
  end

  it 'Allows to pass single attribute as response_group' do
    stub_request(:get, api_url).to_return(body: 'ok')

    url_info = Awis::API::UrlInfo.new
    url_info.fetch(url: 'multifocus.com.b', response_group: 'rank')
    assert_equal ['rank'], url_info.arguments[:response_group]
  end

  describe 'with multifocus.com.b full response group' do
    before do
      stub_request(:get, api_url).to_return(fixture('url_info/multifocus.txt'))
      @url_info = Awis::Client.new.url_info(url: 'multifocus.com.b')
    end

    it 'Should be return success' do
      assert_equal true, @url_info.success?
    end

    it 'Should be return not_found' do
      assert_equal true, @url_info.not_found?
    end

    it 'Should be return 404' do
      assert_equal 404, @url_info.content_data.data_url
    end

    it 'Should be return 404' do
      assert_equal 404, @url_info.content_data.site_title
    end
  end
end
