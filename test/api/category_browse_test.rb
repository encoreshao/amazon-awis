# frozen_string_literal: true

require_relative './../helper'

describe Awis::API::CategoryBrowse do
  describe 'parsing XML' do
    before do
      Awis.config do |c|
        c.access_key_id = 'key'
        c.secret_access_key = 'secret'
      end

      stub_request(:get, api_url).to_return(fixture('category_browse/card_games.txt'))
      @category_browse = Awis::Client.new.category_browse(path: 'Top/Games/Card_Games')
    end

    it 'Should be has request id' do
      assert_equal 'eb7c3940-6dcf-22e9-ab75-f4ddfb0a982b', @category_browse.request_id
    end

    it 'Should be has success status code' do
      assert_equal 'Success', @category_browse.status_code
    end

    it 'Should be return success' do
      assert_equal true, @category_browse.success?
    end

    it 'Should be return attribute categories' do
      assert_equal 8, @category_browse.categories.size
    end

    it 'Should be return attribute language_categories' do
      assert_equal 20, @category_browse.language_categories.size
    end

    it 'Should be return attribute related_categories' do
      assert_equal 8, @category_browse.related_categories.size
    end

    it 'Should be return attribute letter_bars' do
      assert_equal 36, @category_browse.letter_bars.size
    end
  end
end
