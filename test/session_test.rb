require 'test_helper'

class TestSession < Test::Unit::TestCase
  context 'Authentication' do
    setup do
      @unauthorized_response_mock = mock('Net::HTTPResponse')
      @unauthorized_response_mock.stubs(
        :code => '401',
        :message => "Not Authorized",
        :content_type => "text/html",
        :body => '',
        :header => {
          'www-authenticate' => 'Digest realm="api.constantcontact.com", nonce="ab99e2eb0969a35edaa60ccde8c0f8cc", qop="auth"'
        })

      @http_mock = mock('Net::HTTP')
      Net::HTTP.stubs(:new).returns(@http_mock)

      @session = ConstantContact::Session.new("user", "pass", "key")
    end

    should "authenticate with digest authentication when challenged" do
      @http_mock.expects(:request).returns(@unauthorized_response_mock)
      @http_mock.expects(:request).with(
      @session.get("/ws/customers/user/")
    end
  end
end
