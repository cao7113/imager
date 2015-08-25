root = File.expand_path('..', __FILE__)
$:.unshift root unless $:.include?(root) 

require 'lib/active_record_helper'

ENV['APP_ROOT'] ||= root
#puts "set app_root: #{root}"
ActiveRecordHelper.set_active_record
ActiveRecord::Base.raise_in_transactional_callbacks = true

#config carrierwave after ORM 
require 'carrierwave' 
require 'carrierwave/orm/activerecord'
CarrierWave.configure do |config|
  config.permissions = 0666
  config.directory_permissions = 0777
  config.storage = :file

  #config.ignore_integrity_errors = false
  #config.ignore_processing_errors = false
  #config.ignore_download_errors = false
end

# models
require 'models/topic_uploader'
require 'models/topic'
