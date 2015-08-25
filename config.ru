#!/usr/bin/env rackup

require_relative 'boot'
require_relative 'api/api'

use ActiveRecord::ConnectionAdapters::ConnectionManagement
run Imager::API
