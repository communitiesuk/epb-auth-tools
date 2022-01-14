#!/usr/bin/env bash

cd script/gem-test
echo "Installing bundle..."
bundle install
echo "Where is auth tools?"
bundle show epb-auth-tools
echo "Running the Ruby..."
bundle exec ruby token.rb
