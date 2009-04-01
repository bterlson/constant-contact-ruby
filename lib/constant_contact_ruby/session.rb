require 'rubygems'
require 'oauth'
require 'nokogiri'

module ConstantContact
  class Session
    def initialize(username, key, secret)
      @consumer = OAuth::Consumer.new(key, secret, {
                                        :site => "http://api.constantcontact.com",
                                        :request_token_path => "/ws/oauth_get_request_token",
                                        :access_token_path => "/ws/oauth_get_access_token",
                                        :authorize_path => "/ws/oauth_authorize_token"
                                      })

      @username = username
    end

    # Asks Constant Contact for an OAuth request token
    def get_request_token
      @request_token = @consumer.get_request_token
    end

    # Exchanges our request token for an access token and stores it away for later
    def get_access_token
      @access_token = @request_token.get_access_token
    end

    # Use an access token that has been previously generated.
    def use_access_token(token, secret)
      @access_token = OAuth::AccessToken.new(@consumer, token, secret)
    end

    # 
    def contacts(id = nil)
      if id == nil then
        raise "Not Implemented"
      else
        Contact.from_xml(get("contacts/#{id}"), self)
      end
    end

    def get(path, params = "")
      raise "No access token found" if @access_token.nil?

      response = @access_token.get("/ws/customers/#{@username}/#{path}?#{params}")
      results = Nokogiri::XML.parse(response.body)

      return results.xpath('//ns:content/*[1]', 'ns' => "http://www.w3.org/2005/Atom").first, 
    end
  end

end
