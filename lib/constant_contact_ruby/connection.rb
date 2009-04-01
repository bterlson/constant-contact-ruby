require 'net/http'
require 'digest/md5'

module ConstantContact
  class Connection
    DOMAIN = "api.constantcontact.com".freeze

    def initialize(username, password, key) 
      @username = username
      @password = password
      @api_key = key
      @http_login = "#{key}%#{username}"
      @client = Net::HTTP.new(DOMAIN)
      @base_url = "/ws/customers/#{@username}"
      @authentication_params = {}
      @nonce_count = 0
      @cookies = {}
    end

    # Send a get request to the specified path.
    def get(path)
      req = Net::HTTP::Get.new(@base_url + path)
      response = handle_request(req)
      response.each {|k,v| puts "#{k}: #{v}"}
      response
    end

    private

    # Send the request to the server. If the response is unauthorized, an attempt to log in using http digest
    # authentication is made.
    #
    def handle_request(request) 
      add_cookies!(request)
      authenticate_request!(request)
      response = @client.request(request)
      
      set_cookies(response)
      
      case response
      when Net::HTTPUnauthorized
        response = respond_to_challenge(request, response)
      end
    end

    # Adds authentication information to the request based on the challenge from the response.
    #
    def respond_to_challenge(request, response)
      authenticate_header = response['www-authenticate'].downcase
      authenticate_header.sub!(/^digest /, '')

      @authentication_params = authenticate_header.split(", ").inject({}) { |h, field|
        key, value = field.split("=")
        h[key] = value.gsub(/^"|"$/, '') # strip quotes.
        
        h
      }
      add_cookies!(request)
      authenticate_request!(request)
      request.each{|k,v| puts "#{k}: #{v}" }
      # Resend the request
      @client.request(request)
    end

    # Does the legwork for HTTP Digest authentication (See http://www.ietf.org/rfc/rfc2617.txt).
    #
    def authenticate_request!(request)
      return if @authentication_params.empty?
      
      puts "AUTHENTICATION PARAMS: #{@authentication_params.inspect}"
      @nonce_count += 1
      cnonce = Digest::MD5.hexdigest(Time.now.to_s + rand(65535).to_s)
      a1 = "#{@http_login}:#{@authentication_params['realm']}:#{@password}"
      a2 = "#{request.method}:#{request.path}"

      response_digest = Digest::MD5.hexdigest(a1) << ':' <<
                        @authentication_params['nonce'] << ':' <<
                        ('%08x' % @nonce_count) << ':' <<
                        cnonce << ':' <<
                        @authentication_params['qop'] << ':' <<
                        Digest::MD5.hexdigest(a2)

      request['Authorization'] = "Digest username=\"#{@http_login}\", " <<
                                 "realm=\"#{@authentication_params['realm']}\", " <<
                                 "nonce=\"#{@authentication_params['nonce']}\", " <<
                                 "uri=\"#{request.path}\", " <<
                                 "nc=#{'%08x' % @nonce_count}, " <<
                                 "qop=\"#{@authentication_params['qop']}\", " <<
                                 "cnonce=\"#{cnonce}\", " <<
                                 "response=\"#{Digest::MD5.hexdigest(response_digest)}\""
    end
    
    # Adds the cookie header. ConstantContact uses some sort of load balancer and requires cookies to keep track of
    # session state. Without rudimentary cookie support, interfacing with the API is impossible.
    #
    def add_cookies!(request)
      request['Cookie'] = @cookies.collect{|k, v| "#{k}=#{v}"}.join(", ")
    end

    # Stores cookies in the response for later use
    #
    def set_cookies(response)
      cookie_str = response.header['set-cookie']
      return if cookie_str.nil?

      fields = cookie_str.split("; ").inject({}) { |h, field|
        key, value = field.split("=")
        h[key] = value

        h
      }

      # This is obviously not a generalized cookie implementation. Heh.
      fields.delete('path')
      @cookies = fields
    end
  end
end
