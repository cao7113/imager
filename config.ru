#!/usr/bin/env rackup

require_relative 'boot'
require_relative 'api/api'
require_relative 'web'

use ActiveRecord::ConnectionAdapters::ConnectionManagement

map '/api' do
  run Imager::API
end

run Sinatra::Application
