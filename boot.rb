root = File.expand_path('..', __FILE__)
$:.unshift root unless $:.include?(root) 

require 'lib/app_helper'
require 'lib/active_record_helper'

puts "==using app env: #{app_env}"
set_app_root root
when_not_env :production do
  require 'byebug'
end

ActiveRecordHelper.set_active_record
ActiveRecordHelper.enable_active_record_logger
ActiveRecord::Base.raise_in_transactional_callbacks = true

#NOTE: after ORM 
require 'carrierwave' 
require 'lib/carrierwave_ext'
require 'carrierwave/orm/activerecord'

CarrierWave.root = root + '/public'
when_env :test do
  CarrierWave.root = root + '/tmp'
end
when_env :production do
  CarrierWave.root = '/data/imager'
end

# 支持保留中文名上传信息
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/ #/[^a-zA-Z0-9\.\-\+_]/
CarrierWave.configure do |config|
  #config.permissions = 0644
  #config.directory_permissions = 0755
  #config.storage = :file
end

# models
require 'models/topic'
