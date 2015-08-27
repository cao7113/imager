require 'rack/test'
require 'factory_girl'
require 'carrierwave'
require 'active_support'
require 'database_cleaner'
require_relative '../lib/carrierwave_ext'

# NOTE: also support run rspec in development mode for convenience !
ENV['APP_ENV'] ||= 'test'

class CarrierWave::Uploader::Base
  extend ActiveSupport::DescendantsTracker
end

require_relative '../boot'
require 'api/api'
require_relative 'helpers/resp_helpers'

if has_env?(:debug)
  class CarrierWave::Uploader::Base
    module Inspector

      def log tag, msg
        puts "#" * 8 + tag.to_s + "#" * 8
        puts "  input: " << msg
        puts 
        puts "  context: " << self.class.name << '  current file: ' << self.file.inspect
      end

      def cache!(new_file = sanitized_file)
        log :cache!, new_file.inspect
        super
      end

      def process!(new_file=nil)
        log :process!, new_file ? new_file.inspect : ''
        super
      end

      def store!(new_file=nil)
        log :store!, new_file ? new_file.inspect : ''
        super
      end
    end # Inspector

    include Inspector 
  end

  CarrierWave::SanitizedFile.class_eval <<-Code
    def move_to_with_inspect(new_path, permissions=nil, directory_permissions=nil)
      puts "--move \#{self.path} --> " << new_path
      move_to_without_inspect new_path, permissions, directory_permissions
    end

    def copy_to_with_inspect(new_path, permissions=nil, directory_permissions=nil)
      puts "--copy \#{self.path} --> " << new_path
      copy_to_without_inspect new_path, permissions, directory_permissions
    end

    alias_method_chain :move_to, :inspect
    alias_method_chain :copy_to, :inspect
  Code
end

#DatabaseCleaner.strategy = :transaction #as default, others: transaction, deletion

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods
  config.include RespHelpers

  when_env :test do
    config.after do
      CarrierWave::Uploader::Base.descendants.map{ |u| File.join(CarrierWave.root, u.store_dir) }.uniq.each do |dir|
        if File.exists? dir
          #puts "====test rm #{dir} "
          FileUtils.rm_rf dir 
        end
      end
    end

    config.around(:each) do |example|
      DatabaseCleaner.cleaning do
        example.run
      end
    end
  end
end
