# frozen_string_literal: true

require "sinatra"
require_relative "../../../lib/epb-auth-tools"

class AppService < Sinatra::Base
  set(:jwt_auth) do
    condition do
      Auth::Sinatra::Conditional.process_request env
    rescue Auth::Errors::Error => e
      content_type :json
      halt 401, { error: e }.to_json
    end
  end

  get "/", jwt_auth: [] do
    content_type :json
    status 200
    { message: "authenticated" }.to_json
  end
end
