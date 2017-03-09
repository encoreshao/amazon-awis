require "cgi"
require "base64"
require "openssl"
require "digest/sha1"
require "faraday"
require "time"

module Awis
  class Connection
    attr_accessor :access_key_id, :secret_access_key, :proxy, :debug
    attr_writer :params

    RFC_3986_UNRESERVED_CHARS = "-_.~a-zA-Z\\d".freeze

    def initialize
      raise CertificateError.new("Amazon access certificate is missing!") if Awis.config.access_key_id.nil? || Awis.config.secret_access_key.nil?

      @access_key_id  = Awis.config.access_key_id
      @secret_access_key  = Awis.config.secret_access_key
      @debug = Awis.config.debug || nil
    end

    def params
      @params ||= {}
    end

    def get(params = {})
      self.params = params

      handle_response(request).body.force_encoding(Encoding::UTF_8)
    end

    def handle_response(response)
      case response.status.to_i
      when 200...300
        response
      when 300...600
        if response.body.nil?
          raise ResponseError.new(nil, response)
        else
          xml = MultiXml.parse(response.body)
          message = xml["Response"]["Errors"]["Error"]["Message"]
          raise ResponseError.new(message, response)
        end
      else
        raise ResponseError.new("Unknown code: #{respnse.code}", response)
      end
    end

    def request
      puts "[DEBUG] -> #{uri}" if debug
      
      Faraday.get(uri)
    end

    def timestamp
      @timestamp ||= Time::now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    end

    def signature
      Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), secret_access_key, sign)).strip
    end

    def uri
      URI.parse("http://#{Awis::API_HOST}/?" + query + "&Signature=" + CGI::escape(signature))
    end

    def default_params
      {
        "AWSAccessKeyId"   => access_key_id,
        "SignatureMethod"  => "HmacSHA256",
        "SignatureVersion" => "2",
        "Timestamp"        => timestamp,
        "Version"          => Awis::API_VERSION
      }
    end

    def sign
      "GET\n" + Awis::API_HOST + "\n/\n" + query
    end

    def query
      default_params.merge(params).map { |key, value| "#{key}=#{regexp_params(value)}" }.sort.join("&")
    end

    def regexp_params(value)
      URI.escape(value.to_s, Regexp.new("[^#{RFC_3986_UNRESERVED_CHARS}]"))
    end
  end
end
