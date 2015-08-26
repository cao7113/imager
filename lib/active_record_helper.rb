require 'pathname'
require 'erb'
require 'active_record'

module ActiveRecordHelper

  extend self

  def db_app_root
    return @_db_app_root if @_db_app_root
    raise 'not setup env APP_ROOT' unless ENV['APP_ROOT']
    @_db_app_root ||= Pathname.new(ENV['APP_ROOT']).expand_path 
  end

  def db_env
    ENV['APP_ENV'] || 'development'
  end

  def db_conf_file
    return @_conf_file if @_conf_file
    file = db_app_root.join 'database.yml' 
    return @_conf_file = file if file.exist?
    file = db_app_root.join 'config/database.yml' 
    return @_conf_file = file if file.exist?
    raise 'Not found db conf file in [config/]database.yml'
  end

  def db_path
    db_app_root.join('db')
  end

  def db_confs
    return @_db_confs if @_db_confs
    file = db_conf_file
    data = ERB.new(file.read).result
    confs = YAML.load(data)
    @_db_confs = confs
  end

  def connect_active_record
    ActiveRecord::Base.establish_connection db_env.to_sym
  end

  def set_active_record
    ActiveRecord::Base.configurations = db_confs
    connect_active_record
  end

  def enable_active_record_logger(path=nil)
    path ||= db_app_root.join('log/ar.log')
    ActiveRecord::Base.logger = Logger.new(path)
  end

  def conf_active_record_tasks
    ar_tasks = ActiveRecord::Tasks::DatabaseTasks
    ar_tasks.root = db_app_root
    ar_tasks.database_configuration = db_confs
    ar_tasks.env = db_env
    ar_tasks.db_dir = db_path
    ar_tasks.migrations_paths = [db_path.join('migrate')]
    ar_tasks.seed_loader = Seeder.new db_path.join('seeds.rb')
    ar_tasks.fixtures_path = db_app_root.join 'test/fixtures', db_env
  end

  class Seeder
    def initialize(seed_file)
      @seed_file = seed_file
    end

    def load_seed
      raise "Seed file '#{@seed_file}' does not exist" unless File.file?(@seed_file)
      load @seed_file
    end
  end
end
