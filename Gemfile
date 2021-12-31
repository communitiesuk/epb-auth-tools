# frozen_string_literal: true

ruby '~>2.6'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

source 'https://rubygems.org' do
  group :development do
    gem 'rack-test', '~> 1.1'
    gem 'rake', '~> 13.0'
    gem 'rspec', '~> 3.10'
    gem 'rubocop-govuk', require: false
    gem 'sinatra', '~> 2.0'
    gem 'uuid', '~> 2.3'
    gem 'webmock', '~> 3.14'
    gem 'zeitwerk', '~> 2.5'
  end

  gem 'jwt', '~> 2.3'
  gem 'oauth2', '~> 1.4'
end
