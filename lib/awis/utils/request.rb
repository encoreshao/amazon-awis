require "cgi"
require "base64"
require "openssl"
require "uri"
require "net/https"
require "time"

module Awis
  module Utils
    module Request
      def getSignatureKey(key, dateStamp, regionName, serviceName)
        kDate    = OpenSSL::HMAC.digest(encryption_method, aws4 + key, dateStamp)
        kRegion  = OpenSSL::HMAC.digest(encryption_method, kDate, regionName)
        kService = OpenSSL::HMAC.digest(encryption_method, kRegion, serviceName)
        kSigning = OpenSSL::HMAC.digest(encryption_method, kService, aws4_request)
        kSigning
      end

      # escape str to RFC 3986
      def escapeRFC3986(str)
        URI.escape(str, /[^A-Za-z0-9\-_.~]/)
      end

      def timestamp
        Time::now.utc.strftime("%Y%m%dT%H%M%SZ")
      end

      def datestamp
        Time::now.utc.strftime("%Y%m%d")
      end

      def headers
        {
          "host"        => Awis::SERVICE_ENDPOINT,
          "x-amz-date"  => timestamp
        }
      end

      def query_str
        params.sort.map{|k,v| k + "=" + escapeRFC3986(v.to_s())}.join('&')
      end

      def headers_str
        headers.sort.map{|k,v| k + ":" + v}.join("\n") + "\n"
      end

      def headers_lst
        headers.sort.map{|k,v| k}.join(";")
      end

      def payload_hash
        Digest::SHA256.hexdigest ""
      end

      def canonical_request
        "GET" + "\n" + Awis::SERVICE_URI + "\n" + query_str + "\n" + headers_str + "\n" + headers_lst + "\n" + payload_hash
      end

      def algorithm
        "AWS4-HMAC-SHA256"
      end

      def credential_scope
        datestamp + "/" + Awis::SERVICE_REGION + "/" + Awis::SERVICE_NAME + "/" + aws4_request
      end

      def string_to_sign
        algorithm + "\n" +  timestamp + "\n" +  credential_scope + "\n" + (Digest::SHA256.hexdigest canonical_request)
      end

      def signing_key
        getSignatureKey(Awis.config.secret_access_key, datestamp, Awis::SERVICE_REGION, Awis::SERVICE_NAME)
      end

      def signature
        OpenSSL::HMAC.hexdigest(encryption_method, signing_key, string_to_sign)
      end

      def authorization_header
        algorithm + " " +
          "Credential=" + Awis.config.access_key_id + "/" + credential_scope + ", " +
          "SignedHeaders=" + headers_lst + ", " +
          "Signature=" + signature;
      end

      def uri
        URI(url + url_params)
      end

      def request
        puts "Making request to: \n #{uri} \n\n"
        req = Net::HTTP::Get.new(uri)
        req["Accept"]         = "application/xml"
        req["Content-Type"]   = "application/xml"
        req["x-amz-date"]     = timestamp
        req["Authorization"]  = authorization_header

        response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') { |http|
          http.request(req)
        }

        response
      end

      def handle_response(response)
        case response.code.to_i
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

      def aws4
        "AWS4"
      end

      def aws4_request
        "aws4_request"
      end

      def encryption_method
        'sha256'
      end

      def url
        protocol + '://' + Awis::SERVICE_HOST + Awis::SERVICE_URI
      end

      def url_params
        '?' + query_str
      end
    end
  end
end
