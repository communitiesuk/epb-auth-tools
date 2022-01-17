# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = "epb-auth-tools"
  s.version = "1.0.8"
  s.date = "2021-06-23"
  s.summary = "Tools for authentication and authorisation with JWTs and OAuth"
  s.license = "MIT"
  s.required_ruby_version = ">= 2.7.0"
  s.homepage = "https://github.com/communitiesuk/epb-auth-tools"
  s.authors = [
    "Lawrence Goldstien <lawrence.goldstien@madetech.com>",
    "Yusuf Sheikh <yusuf@madetech.com>",
    "Jaseera <jaseera@madetech.com>",
    "Kevin Keenoy <kevin.keenoy@communities.gov.uk>",
    "Douglas Greenshields <douglas.greenshields@communities.gov.uk>",
  ]
  s.files = %w[lib/epb-auth-tools.rb
               lib/errors.rb
               lib/http_client.rb
               lib/token.rb
               lib/token_processor.rb
               lib/sinatra/conditional.rb]
  s.add_runtime_dependency "jwt", ["~> 2.3"]
  s.add_runtime_dependency "oauth2", ["~> 1.4"]
  s.require_paths = %w[lib]
end
