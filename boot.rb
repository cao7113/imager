root = File.expand_path('..', __FILE__)
$:.unshift root unless $:.include?(root) 

require 'lib/app_helper'
require 'lib/active_record_helper'

set_app_root root
when_env :development do
  require 'byebug'
end

ActiveRecordHelper.set_active_record
ActiveRecord::Base.raise_in_transactional_callbacks = true

#NOTE: after ORM 
require 'carrierwave' 
require 'lib/carrierwave_ext' 
require 'carrierwave/orm/activerecord'

CarrierWave.root = root + '/public'
#when_env :test do
  #CarrierWave.root += '/tmp'
#end

# 支持保留中文名上传信息
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/ #/[^a-zA-Z0-9\.\-\+_]/
CarrierWave.configure do |config|
  #config.permissions = 0644
  #config.directory_permissions = 0755
  #config.storage = :file
end

# models
require 'models/topic'
