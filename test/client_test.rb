# frozen_string_literal: true

require_relative './helper'

describe Awis::Client do
  it 'raises Argument Error when access_key_id not present' do
    Awis.config do |c|
      c.access_key_id = nil
      c.secret_access_key = nil
    end

    assert_raises Awis::CertificateError, /certificate/ do
      Awis::Client.new
    end
  end

  it 'raises Argument Error when secret_access_key not present' do
    assert_raises Awis::CertificateError, /certificate/ do
      Awis.config do |c|
        c.access_key_id = 'key'
        c.secret_access_key = nil
      end

      Awis::Client.new
    end
  end

  it 'get Awis config keys' do
    Awis.config do |c|
      c.access_key_id = 'key'
      c.secret_access_key = 'secret'
    end

    assert_equal(Awis.config.access_key_id, 'key')
    assert_equal(Awis.config.secret_access_key, 'secret')
  end
end
