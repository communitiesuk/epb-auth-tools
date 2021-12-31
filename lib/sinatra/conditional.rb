# frozen_string_literal: true

module Auth
  module Sinatra
    class Conditional
      def self.process_request(env)
        jwt_token = env.fetch("HTTP_AUTHORIZATION", "").slice(7..-1)
        processor =
          Auth::TokenProcessor.new ENV["JWT_SECRET"], ENV["JWT_ISSUER"]
        processor.process jwt_token
      end
    end
  end
end
