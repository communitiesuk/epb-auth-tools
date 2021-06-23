require 'rspec'

describe Auth::HttpClient do
  before do
    @auth_server = 'http://localhost:9292'
    @base_uri = 'http://example.com'
    @client_id = 'client-id'
    @client_secret = 'client-secret'
  end

  context 'instantiated with incorrect arguments' do
    it 'raises Auth::Errors::ClientHasNoClientId when no client_id' do
      expect {
        Auth::HttpClient.new
      }.to raise_error instance_of Auth::Errors::ClientHasNoClientId
    end

    it 'raises Auth::Errors::ClientHasNoClientSecret with no client_secret' do
      expect {
        Auth::HttpClient.new 'client-id'
      }.to raise_error instance_of Auth::Errors::ClientHasNoClientSecret
    end

    it 'raises Auth::Errors::ClientHasNoAuthServer with no auth_server' do
      expect {
        Auth::HttpClient.new 'client-id', 'client-secret'
      }.to raise_error instance_of Auth::Errors::ClientHasNoAuthServer
    end

    it 'raises Auth::Errors::ClientHasNoBaseUri with no auth_server' do
      expect {
        Auth::HttpClient.new 'client-id', 'client-secret', 'http://bbc.co.uk'
      }.to raise_error instance_of Auth::Errors::ClientHasNoBaseUri
    end
  end

  context 'instantiated with correct arguments' do
    let(:client) do
      Auth::HttpClient.new @client_id,
                           @client_secret,
                           @auth_server,
                           @base_uri,
                           OAuth2Stub::Client
    end

    it 'allows refreshing a token' do
      expect { client.refresh }.to_not raise_error
    end

    it 'can call get' do
      expect(client.get('/get')).to be_instance_of OAuth2::Response
    end

    it 'can call post' do
      expect(client.post('/post')).to be_instance_of OAuth2::Response
    end

    it 'can call put' do
      expect(client.put('/put')).to be_instance_of OAuth2::Response
    end

    it 'calling get and receiving HTML does not raise an error' do
      expect(client.get('/get/html')).to be_instance_of OAuth2::Response
    end
  end

  context 'instantiated with correct arguments but expired' do
    let(:client) do
      Auth::HttpClient.new @client_id,
                           @client_secret,
                           @auth_server,
                           @base_uri,
                           OAuth2Stub::Client
    end

    it 'calling get results in a token refresh request when body available as string' do
      client.refresh

      allow(client).to receive :refresh

      expect(client.get('/get/expired')).to be_instance_of OAuth2::Response

      expect(client).to have_received :refresh
    end

    it 'calling get results in a token refresh request when body available as hash of decoded JSON' do
      client.refresh

      allow(client).to receive :refresh

      expect(client.get('/get/expired-decoded-json')).to be_instance_of OAuth2::Response

      expect(client).to have_received :refresh
    end
  end

  context 'when the auth server is not running at the root of the hostname' do
    let(:client) do
      Auth::HttpClient.new @client_id,
                           @client_secret,
                           @auth_server + '/prefix',
                           'http://localhost:19299',
                           OAuth2::Client
    end

    it 'the client makes a request on the prefix address' do
      response_body = {
        access_token: token_generate(:valid_token),
        token_type: 'bearer',
        expires_in: 3_600
      }.to_json

      token_request =
        stub_request(:post, @auth_server + '/prefix/oauth/token').to_return(
          status: 200,
          body: response_body,
          headers: {
            'Content-Length' => response_body.length,
            'Content-Type' => 'application/json'
          }
        )

      client.refresh

      expect(token_request).to have_been_requested
    end
  end

  context 'when there is no connection' do
    let(:client) do
      Auth::HttpClient.new @client_id,
                           @client_secret,
                           @auth_server,
                           'http://localhost:19299',
                           OAuth2Stub::Client
    end

    it 'raises Auth::Errors::NetworkConnectionFailed' do
      expect {
        client.get('/get/network_error')
      }.to raise_error instance_of Auth::Errors::NetworkConnectionFailed
    end
  end
end
