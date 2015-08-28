require 'byebug'
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

      def log tag, msg=''
        puts "#" * 8 + tag.to_s + "#" * 8
        puts "  input: " << msg
        puts "  context: " << self.class.name << '  current file: ' << "#{self.file.try(:path)}"
      end

      def cache!(new_file = sanitized_file)
        log :cache!, new_file.inspect
        super
      end

      def process!(new_file=nil)
        log :process! , new_file ? new_file.inspect : ''
        super
      end

      def store!(new_file=nil)
        log :store!, new_file ? new_file.inspect : ''
        super
      end

      def remove!
        log :remove!
        super
      end
    end # Inspector

    include Inspector 
  end # Base

  ## debug
  Uploaders::Base.class_eval <<-Code
    def manipulate_with_inspect! &block
      log :manipulate!, '=========='
      manipulate_without_inspect! &block
    end

    alias_method_chain :manipulate!, :inspect
  Code

  CarrierWave::SanitizedFile.class_eval <<-Code
    def move_to_with_inspect(new_path, permissions=nil, directory_permissions=nil)
      puts "  --!!!MOVE \#{self.path} --> "
      puts new_path
      move_to_without_inspect new_path, permissions, directory_permissions
    end
    alias_method_chain :move_to, :inspect

    def copy_to_with_inspect(new_path, permissions=nil, directory_permissions=nil)
      puts "  --!!!COPY \#{self.path} --> "
      puts new_path
      copy_to_without_inspect new_path, permissions, directory_permissions
    end
    alias_method_chain :copy_to, :inspect

    def delete_with_inspect
      puts "  --!!!DELETE \#{self.path}"
      delete_without_inspect
    end
    alias_method_chain :delete, :inspect
  Code
end

#transaction as default, other: truncation , deletion
DatabaseCleaner.strategy = $cleaner_strategy = :transaction #truncation #deletion 

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
